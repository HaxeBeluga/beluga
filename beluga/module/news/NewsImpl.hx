package beluga.module.news;

import haxe.xml.Fast;
import sys.db.Manager;

import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.core.module.ModuleImpl;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;
import sys.db.Types;

class NewsList {
    public var title : String;
    public var text : String;
    public var id : Int;
    public var pos : Int;
    public var creationDate : SDateTime;

    public function new(t : String, te : String, i : Int, p : Int, d: SDateTime) {
        title = t;
        text = te;
        id = i;
        pos = p;
        creationDate = d;
        if (text.length > 200) {
            text = text.substr(0, 200) + "...";
        }
    }
}

class NewsData {
    public var text : String;
    public var login : String;
    public var date : SDateTime;
    public var com_id : Int;

    public function new(t : String, l : String, d : SDateTime, c : Int) {
        text = t;
        login = l;
        date = d;
        com_id = c;
    }
}

class NewsImpl extends ModuleImpl implements NewsInternal {
    public var triggers = new NewsTrigger();

    // Context variables
    private var error_msg : String;
    private var success_msg : String;

    // Forms variables in case something fail
    private var title : String;
    private var news_text : String;

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
        title = "";
        news_text = "";
    }

	override public function initialize(beluga : Beluga) : Void {

	}

    public function getDefaultContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var t_news = this.getAllNews();
        var news = new Array<NewsList>();
        var pos = 0;

        for (tmp in t_news) {
            news.push(new NewsList(tmp.title, tmp.text, tmp.id, pos, tmp.creationDate));
            if (pos == 0)
                pos = 1;
            else
                pos = 0;
        }
        return {news : news, error : error_msg, success : success_msg, path : "/beluga/news/", user: user};
    }

    public function getCreateContext() : Dynamic {
        return {path : "/beluga/news/", title : title, error : error_msg, data : news_text};
    }

    public function getEditContext(news_id: Int) : Dynamic {
        return {path : "/beluga/news/", news : NewsModel.manager.get(news_id), error : error_msg};
    }

    public function getPrintContext(news_id: Int) : Dynamic {
        var t_comments = getComments(news_id);
        var comments_list = new Array<NewsData>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var news = NewsModel.manager.get(news_id);

        for (comment in t_comments) {
            comments_list.push(new NewsData(comment.text, comment.user.login, comment.creationDate, comment.id));
        }

        return {news : news, comments : comments_list, path : "/beluga/news/",
            user : user, error : error_msg, success : success_msg};
    }

    public function canEdit(news_id: Int, user_id: Int) : Bool {
        var n = NewsModel.manager.get(news_id);

        if (n == null || n.user_id != user_id) {
            error_msg = "You can't edit this news";
            return false;
        }
        return true;
    }

    public function canPrint(news_id: Int) : Bool {
        var news = NewsModel.manager.get(news_id);

        if (news == null) {
            error_msg = "News hasn't been found...";
            return false;
        }
        return true;
    }

    public function getAllNews() : Array<NewsModel> {
        var ret = new Array<NewsModel>();

        var row = Manager.cnx.request("SELECT * from beluga_news_news ORDER BY creationDate DESC");
        for (tmp in row)
            ret.push(tmp);
        return ret;
    }

    public function getNewsFromUser(user_id : Int) : Array<NewsModel> {
        var ret = new Array<NewsModel>();

        for (tmp in NewsModel.manager.dynamicSearch({user_id : user_id}))
            ret.push(tmp);
        return ret;
    }

    public function getComments(news_id : Int) : Array<CommentModel> {
        var ret = new Array<CommentModel>();

        var row = Manager.cnx.request("SELECT * from beluga_news_comment WHERE news_id=" + news_id + " ORDER BY creationDate");
        for (tmp in row) {
            for (tmp2 in CommentModel.manager.dynamicSearch( {id : tmp.id} )) {
                ret.push(tmp2);
                break;
            }
        }
        return ret;
    }

    public function edit(args : {news_id : Int, title : String, text : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "Please login before edit this news";
            this.triggers.editFail.dispatch({news_id : args.news_id});
            return;
        }
        for (tmp in NewsModel.manager.dynamicSearch( {user_id : user.id, id : args.news_id} )) {
            tmp.title = args.title;
            tmp.text = args.text;
            tmp.update();
            success_msg = "News has been successfully edited !";
            this.triggers.editSuccess.dispatch({news_id : args.news_id});
            return;
        }
        error_msg = "You can't edit this news";
        this.triggers.editFail.dispatch({news_id : args.news_id});
    }

    public function addComment(args : {news_id : Int, text : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "You need to be logged to post a comment";
            this.triggers.addCommentFail.dispatch({news_id : args.news_id});
            return;
        }
        if (args.text == "") {
            error_msg = "Comment cannot be empty";
            this.triggers.addCommentFail.dispatch({news_id : args.news_id});
            return;
        }
        for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id} )) {
            var com = new CommentModel();

            com.text = args.text;
            com.news_id = args.news_id;
            com.user_id = user.id;
            com.creationDate = Date.now();
            com.insert();
            success_msg = "Comment has been successfully added !";
            this.triggers.addCommentSuccess.dispatch({news_id : args.news_id});
            return;
        }
        error_msg = "News cannot be found";
        this.triggers.addCommentFail.dispatch({news_id : args.news_id});
    }

    public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
                for (tmp_c in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id} )) {
                    tmp_c.delete();
                    success_msg = "Comment has been deleted successfully";
                    this.triggers.deleteCommentSuccess.dispatch({news_id : args.news_id});
                    return;
                }
                error_msg = "This comment doesn't exist";
                this.triggers.deleteCommentFail.dispatch({news_id : args.news_id});
                return;
            }
            success_msg = "Comment has been deleted successfully";
            for (tmp in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id, user_id : user.id} )) {
                tmp.delete();
                this.triggers.deleteCommentSuccess.dispatch({news_id : args.news_id});
                return;
            }
        }
        error_msg = "You can't delete this comment";
        this.triggers.deleteCommentFail.dispatch({news_id : args.news_id});
    }

    public function print(args : {news_id : Int}) {
        this.triggers.print.dispatch(args);
    }

    public function delete(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "You have to be logged to do that";
            this.triggers.deleteFail.dispatch({news_id: args.news_id});
        }
        for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
            for (tmp_c in CommentModel.manager.dynamicSearch({news_id : tmp.id})) {
                tmp_c.delete();
            }
            tmp.delete();
            success_msg = "News has been successfully deleted !";
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        error_msg = "You can't delete this news";
        this.triggers.deleteFail.dispatch({news_id: args.news_id});
    }

    public function create(args : {title : String, text : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        title = args.title;
        news_text = args.text;
        if (user == null) {
            error_msg = "Please log in to create a news";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.title == "") {
            error_msg = "Please enter a title";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.text == "") {
            error_msg = "Please enter the text of the news";
            this.triggers.createFail.dispatch();
            return;
        }
        var news = new NewsModel();

        news.title = args.title;
        news.text = args.text;
        news.user_id = user.id;
        news.creationDate = Date.now();
        news.insert();
        success_msg = "News has been successfully created !";
        this.triggers.createSuccess.dispatch();
    }
}