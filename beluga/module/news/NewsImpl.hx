package beluga.module.news;

import haxe.xml.Fast;
import sys.db.Manager;

import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.core.module.ModuleImpl;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;

class NewsImpl extends ModuleImpl implements NewsInternal {
    public var triggers = new NewsTrigger();

    public function new() {
        super();
    }

	override public function initialize(beluga : Beluga) : Void {

	}

    public function getAllNews() : Array<NewsModel> {
        var ret = new Array<NewsModel>();

        var row = Manager.cnx.request("SELECT * from beluga_news_news ORDER BY creationDate DESC");
        for (tmp in row)
            ret.push(tmp);
        return ret;
    }

    public function getNews(args : {user_id : Int}) : Array<NewsModel> {
        var ret = new Array<NewsModel>();

        for (tmp in NewsModel.manager.dynamicSearch( {user_id : args.user_id} ))
            ret.push(tmp);
        return ret;
    }

    public function getComments(args : {news_id : Int}) : Array<CommentModel> {
        var ret = new Array<CommentModel>();

        var row = Manager.cnx.request("SELECT * from beluga_news_comment WHERE news_id=" + args.news_id + " ORDER BY creationDate");
        for (tmp in row) {
            for (tmp2 in CommentModel.manager.dynamicSearch( {id : tmp.id} )) {
                ret.push(tmp2);
                break;
            }
        }
        Sys.print(ret.length);
        return ret;
    }

    public function edit(args : {news_id : Int, title : String, text : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.editFail.dispatch({news_id : args.news_id, error : "Please login before edit this news"});
            return;
        }
        for (tmp in NewsModel.manager.dynamicSearch( {user_id : user.id, id : args.news_id} )) {
            tmp.title = args.title;
            tmp.text = args.text;
            tmp.update();
            this.triggers.editSuccess.dispatch({news_id : args.news_id});
            return;
        }
        this.triggers.editFail.dispatch({news_id : args.news_id, error : "You can't edit this news"});
    }

    public function addComment(args : {news_id : Int, text : String}) : Void {
        if (args.text == "") {
            this.triggers.addCommentFail.dispatch({news_id : args.news_id, error: "Comment cannot be empty"});
            return;
        }
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.addCommentFail.dispatch({news_id : args.news_id, error: "You need to be logged to post a comment"});
            return;
        }
        for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id} )) {
            var com = new CommentModel();

            com.text = args.text;
            com.news_id = args.news_id;
            com.user_id = user.id;
            com.creationDate = Date.now();
            com.insert();
            this.triggers.addCommentSuccess.dispatch({news_id : args.news_id});
            return;
        }
        this.triggers.addCommentFail.dispatch({news_id : args.news_id, error: "News cannot be found"});
    }

    public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
                for (tmp_c in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id} )) {
                    tmp_c.delete();
                    this.triggers.deleteCommentSuccess.dispatch({news_id : args.news_id});
                    return;
                }
                this.triggers.deleteCommentFail.dispatch({news_id : args.news_id, error : "This comment doesn't exist"});
                return;
            }
            for (tmp in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id, user_id : user.id} )) {
                tmp.delete();
                this.triggers.deleteCommentSuccess.dispatch({news_id : args.news_id});
                return;
            }
        }
        this.triggers.deleteCommentFail.dispatch({news_id : args.news_id, error : "You can't delete this comment"});
    }

    public function print(args : {news_id : Int}) {
        this.triggers.print.dispatch(args);
    }

    public function delete(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
                for (tmp_c in CommentModel.manager.dynamicSearch({news_id : tmp.id})) {
                    tmp_c.delete();
                }
                tmp.delete();
                this.triggers.deleteSuccess.dispatch();
                return;
            }
        }
        this.triggers.deleteFail.dispatch();
    }

    public function create(args : {title : String, text : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null || args.title == "" || args.text == "") {
            if (user == null)
                this.triggers.createFail.dispatch({title : args.title, data : args.text, error : "Please log in to create a news"});
            else if (args.title == "")
                this.triggers.createFail.dispatch({title : args.title, data : args.text, error : "Please enter a title"});
            else
                this.triggers.createFail.dispatch({title : args.title, data : args.text, error : "Please enter the news"});
            return;
        }
        var news = new NewsModel();

        news.title = args.title;
        news.text = args.text;
        news.user_id = user.id;
        news.creationDate = Date.now();
        news.insert();
        this.triggers.createSuccess.dispatch();
    }
}