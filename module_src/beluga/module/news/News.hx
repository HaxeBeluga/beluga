// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.news;

import beluga.module.news.api.NewsApi;
import haxe.xml.Fast;

import sys.db.Manager;
import sys.db.Types;

import beluga.Beluga;
import beluga.module.Module;
import beluga.I18n;

import beluga.module.account.Account;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;
import beluga.module.news.NewsErrorKind;

@:Css("/beluga/module/news/view/css/")
class News extends Module {
    public var triggers = new NewsTrigger();
    public var widgets: NewsWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/news/locale/");

    // Context variables
    public var error_id : NewsErrorKind;
    public var success_msg : String;
    public var actual_news_id : Int;

    // Forms variables in case something fail
    public var title : String;
    public var news_text : String;

    public function new() {
        super();
        error_id = None;
        success_msg = "";
        title = "";
        news_text = "";
        actual_news_id = -1;
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new NewsWidget();
        beluga.api.register("news", new NewsApi(beluga, this));
    }

    public function setActualNewsId(news_id : Int) {
        this.actual_news_id = news_id;
    }

    public function canEdit(news_id: Int, user_id: Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).getUser(user_id);

        if (user == null) {
            return false;
        }
        var news = NewsModel.manager.get(news_id);
        if (news.user_id != user_id && !user.isAdmin) {
            error_id = NotAllowed;
            return false;
        }
        return true;
    }

    public function canPrint(news_id: Int) : Bool {
        var news = NewsModel.manager.get(news_id);

        if (news == null) {
            error_id = NewsNotFound;
            return false;
        }
        return true;
    }

    public function getAllNews() : Array<NewsModel> {
        var news_array = new Array<NewsModel>();

        var all_news = Manager.cnx.request("SELECT * from beluga_news_news ORDER BY creationDate DESC");
        for (news in all_news) {
            // this "loop" fills news structs
            for (filled_news in NewsModel.manager.dynamicSearch({id : news.id})) {
                news_array.push(filled_news);
                break;
            }
        }
        return news_array;
    }

    public function getNewsFromUser(user_id : Int) : Array<NewsModel> {
        var news_array = new Array<NewsModel>();

        for (news in NewsModel.manager.dynamicSearch({user_id : user_id})) {
            for (filled_news in NewsModel.manager.dynamicSearch({id : news.id})) {
                news_array.push(filled_news);
                break;
            }
        }
        return news_array;
    }

    public function getComments(news_id : Int) : Array<CommentModel> {
        var comments_array = new Array<CommentModel>();

        var comments = Manager.cnx.request("SELECT * from beluga_news_comment WHERE news_id=" + news_id + " ORDER BY creationDate");
        for (comment in comments) {
            // this "loop" fills comments structs
            for (filled_comment in CommentModel.manager.dynamicSearch({id : comment.id})) {
                comments_array.push(filled_comment);
                break;
            }
        }
        return comments_array;
    }

    public function edit(args : {news_id : Int, title : String, text : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        this.actual_news_id = args.news_id;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.editFail.dispatch({error : MissingLogin});
            return;
        }
        for (news in NewsModel.manager.dynamicSearch( {id : args.news_id} )) {
            if (news.user_id == user.id || user.isAdmin == true) {
                news.title = args.title;
                news.text = args.text;
                news.update();
                success_msg = "news_edit_success";
                this.triggers.editSuccess.dispatch();
                return;
            }
            error_id = NotAllowed;
            this.triggers.editFail.dispatch({error : NotAllowed});
            break;
        }
        error_id = NewsNotFound;
        this.triggers.editFail.dispatch({error : NewsNotFound});
    }

    public function addComment(args : {news_id : Int, text : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        this.actual_news_id = args.news_id;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.addCommentFail.dispatch({error : MissingLogin});
            return;
        }
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.addCommentFail.dispatch({error : MissingMessage});
            return;
        }
        for (news in NewsModel.manager.dynamicSearch({id : args.news_id})) {
            var comment = new CommentModel();

            comment.text = args.text;
            comment.news_id = args.news_id;
            comment.user_id = user.id;
            comment.creationDate = Date.now();
            comment.insert();
            success_msg = "create_comment_success";
            this.triggers.addCommentSuccess.dispatch();
            return;
        }
        error_id = NewsNotFound;
        this.triggers.addCommentFail.dispatch({error : NewsNotFound});
    }

    public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        this.actual_news_id = args.news_id;
        if (user != null) {
            // we search the news first
            for (news in NewsModel.manager.dynamicSearch({id : args.news_id})) {
                // then we search the comment
                for (comment in CommentModel.manager.dynamicSearch({id : args.comment_id, news_id : args.news_id})) {
                    // If the user is root, the news' creator or the comment's creator
                    if (news.user_id == user.id || comment.user_id == user.id || user.isAdmin) {
                        comment.delete();
                        success_msg = "delete_comment_success";
                        this.triggers.deleteCommentSuccess.dispatch();
                        return;
                    }
                    error_id = NotAllowed;
                    this.triggers.deleteCommentFail.dispatch({error : NotAllowed});
                    return;
                }
                error_id = CommentNotFound;
                this.triggers.deleteCommentFail.dispatch({error : CommentNotFound});
                return;
            }
            error_id = NewsNotFound;
            this.triggers.deleteCommentFail.dispatch({error : NewsNotFound});
        } else {
            error_id = MissingLogin;
            this.triggers.deleteCommentFail.dispatch({error : MissingLogin});
        }
    }

    public function delete(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        this.actual_news_id = args.news_id;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.deleteFail.dispatch({error : MissingLogin});
        }
        // We search the news
        for (news in NewsModel.manager.dynamicSearch( {id : args.news_id} )) {
            // If you are root or the news' creator
            if (news.user_id == user.id || user.isAdmin) {
                // Then we delete all this news' comments
                for (comment in CommentModel.manager.dynamicSearch({news_id : news.id})) {
                    comment.delete();
                }
                news.delete();
                success_msg = "news_delete_success";
                this.triggers.deleteSuccess.dispatch();
                return;
            } else {
                error_id = NotAllowed;
                this.triggers.deleteFail.dispatch({error : NotAllowed});
            }
        }
        error_id = NewsNotFound;
        this.triggers.deleteFail.dispatch({error : NewsNotFound});
    }

    public function create(args : {title : String, text : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        title = args.title;
        news_text = args.text;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.createFail.dispatch({error : NewsNotFound});
            return;
        }
        if (args.title == "") {
            error_id = MissingTitle;
            this.triggers.createFail.dispatch({error : MissingTitle});
            return;
        }
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.createFail.dispatch({error : MissingMessage});
            return;
        }
        var news = new NewsModel();

        news.title = args.title;
        news.text = args.text;
        news.user_id = user.id;
        news.creationDate = Date.now();
        news.insert();
        success_msg = "news_create_success";
        this.triggers.createSuccess.dispatch();
    }

    public function getErrorString(error: NewsErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case MissingMessage: BelugaI18n.getKey(this.i18n, "missing_message");
            case MissingTitle: BelugaI18n.getKey(this.i18n, "missing_title");
            case NewsNotFound: BelugaI18n.getKey(this.i18n, "id_not_found");
            case CommentNotFound: BelugaI18n.getKey(this.i18n, "comment_id_not_found");
            case NotAllowed: BelugaI18n.getKey(this.i18n, "not_allowed");
            case None: null;
        };
    }
}