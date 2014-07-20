package modules.news_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.news.News;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;
import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;
import sys.db.Types;

#if php
import php.Web;
#end

/**
 * @author Guillaume Gomez
 */

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

class NewsTest implements MetadataReader
{
    public var beluga(default, null) : Beluga;
    public var news(default, null) : News;
    private var error_msg : String;
    private var success_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.news = beluga.getModuleInstance(News);
        this.error_msg = "";
        this.success_msg = "";
    }

    @bTrigger("beluga_news_default")
    public static function _doDefault() {
        new NewsTest(Beluga.getInstance()).doDefault();
    }

    public function doDefault() {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var widget = news.getWidget("news");
        var t_news = this.news.getAllNews();
        var news = new Array<NewsList>();
        var pos = 0;

        for (tmp in t_news) {
            news.push(new NewsList(tmp.title, tmp.text, tmp.id, pos, tmp.creationDate));
            if (pos == 0)
                pos = 1;
            else
                pos = 0;
        }
        widget.context = {news : news, error : error_msg, success : success_msg, path : "/newsTest/", user: user};

        var newsWidget = widget.render();

        var html = Renderer.renderDefault("page_news", "News list", {
            newsWidget: newsWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_news_print")
    public static function _doPrint(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doPrint(args);
    }

    public function doPrint(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var news = NewsModel.manager.get(args.news_id);

        if (news == null) {
            error_msg = "News hasn't been found...";
            doDefault();
            return;
        }
        var widget = this.news.getWidget("print");
        var t_comments = this.news.getComments(args);
        var comments_list = new Array<NewsData>();

        for (tmp in t_comments) {
            comments_list.push(new NewsData(tmp.text, tmp.user.login, tmp.creationDate, tmp.id));
        }
        
        widget.context = {news : news, comments : comments_list, path : "/newsTest/",
                            user : user, error : error_msg, success : success_msg};

        var newsWidget = widget.render();

        var html = Renderer.renderDefault("page_news", "News", {
            newsWidget: newsWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_news_redirect")
    public static function _doRedirect() {
        new NewsTest(Beluga.getInstance()).doRedirect();
    }

    public function doRedirect() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }
        var widget = news.getWidget("create");
        widget.context = {path : "/newsTest/"};

        var newsWidget = widget.render();

        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: newsWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_news_redirectEdit")
    public static function _doRedirectEdit(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doRedirectEdit(args);
    }

    public function doRedirectEdit(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }
        var n = NewsModel.manager.get(args.news_id);
        if (n == null || n.user_id != user.id) {
            error_msg = "You can't edit this news";
            doDefault();
            return;
        }
        var widget = news.getWidget("edit");
        widget.context = {path : "/newsTest/", news : n, error : error_msg};

        var newsWidget = widget.render();

        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: newsWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_news_create")
    public static function _doCreate(args : {title : String, text : String}) {
        new NewsTest(Beluga.getInstance()).doCreate(args);
    }

    public function doCreate(args : {title : String, text : String}) {
        this.news.create(args);
    }

    @bTrigger("beluga_news_delete")
    public static function _doDelete(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doDelete(args);
    }

    public function doDelete(args : {news_id : Int}) {
        this.news.delete(args);
    }

    @bTrigger("beluga_news_deleteCom")
    public static function _doDeleteCom(args : {com_id : Int, news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doDeleteCom(args);
    }

    public function doDeleteCom(args : {com_id : Int, news_id : Int}) {
        this.news.deleteComment({news_id : args.news_id, comment_id : args.com_id});
    }

    @bTrigger("beluga_news_deleteComment_fail")
    public static function _doDeleteCommentFail(args : {news_id : Int, error : String}) {
        new NewsTest(Beluga.getInstance()).doDeleteCommentFail(args);
    }

    public function doDeleteCommentFail(args : {news_id : Int, error : String}) {
        error_msg = args.error;
        this.doPrint({news_id : args.news_id});
    }

    @bTrigger("beluga_news_deleteComment_success")
    public static function _doDeleteCommentSuccess(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doDeleteCommentSuccess(args);
    }

    public function doDeleteCommentSuccess(args : {news_id : Int}) {
        success_msg = "Comment has been deleted successfully";
        this.doPrint({news_id : args.news_id});
    }

    @bTrigger("beluga_news_create_fail")
    public static function _doCreateFail(args : {title : String, data : String, error : String}) {
        new NewsTest(Beluga.getInstance()).doCreateFail(args);
    }

    public function doCreateFail(args : {title : String, data : String, error : String}) {
        error_msg = "Error ! News has not been created...";
        var widget = news.getWidget("create");
        widget.context = {path : "/newsTest/", title : args.title, error : args.error, data : args.data};

        var newsWidget = widget.render();

        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: newsWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_news_create_success")
    public static function _doCreateSuccess() {
        new NewsTest(Beluga.getInstance()).doCreateSuccess();
    }

    public function doCreateSuccess() {
        success_msg = "News has been successfully created !";
        this.doDefault();
    }

    @bTrigger("beluga_news_edit_fail")
    public static function _doEditFail(args : {news_id : Int, error : String}) {
        new NewsTest(Beluga.getInstance()).doEditFail(args);
    }

    public function doEditFail(args : {news_id : Int, error : String}) {
        error_msg = args.error;
        this.doRedirectEdit({news_id : args.news_id});
    }

    @bTrigger("beluga_news_edit_success")
    public static function _doEditSuccess(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doEditSuccess(args);
    }

    public function doEditSuccess(args : {news_id : Int}) {
        success_msg = "News has been successfully edited !";
        this.doPrint(args);
    }

    @bTrigger("beluga_news_addComment_success")
    public static function _doAddCommentSuccess(args : {news_id : Int}) {
        new NewsTest(Beluga.getInstance()).doAddCommentSuccess(args);
    }

    public function doAddCommentSuccess(args : {news_id : Int}) {
        success_msg = "Comment has been successfully added !";
        this.doPrint(args);
    }

    @bTrigger("beluga_news_addComment_fail")
    public static function _doAddCommentFail(args : {news_id : Int, error: String}) {
        new NewsTest(Beluga.getInstance()).doAddCommentFail(args);
    }

    public function doAddCommentFail(args : {news_id : Int, error: String}) {
        error_msg = args.error;
        this.doPrint(args);
    }

    @bTrigger("beluga_news_delete_success")
    public static function _doDeleteSuccess() {
        new NewsTest(Beluga.getInstance()).doDeleteSuccess();
    }

    public function doDeleteSuccess() {
        success_msg = "News has been successfully deleted !";
        this.doDefault();
    }

    @bTrigger("beluga_news_delete_fail")
    public static function _doDeleteFail() {
        new NewsTest(Beluga.getInstance()).doDeleteFail();
    }

    public function doDeleteFail() {
        error_msg = "Error: News hasn't been deleted...";
        this.doDefault();
    }

    @bTrigger("beluga_news_createComment")
    public static function _doCreateComment(args : {news_id : Int, text : String}) {
        new NewsTest(Beluga.getInstance()).doCreateComment(args);
    }

    public function doCreateComment(args : {news_id : Int, text : String}) {
        this.news.addComment(args);
    }

    @bTrigger("beluga_news_edit")
    public static function _doEdit(args : {news_id : Int, title : String, text : String}) {
        new NewsTest(Beluga.getInstance()).doEdit(args);
    }

    public function doEdit(args : {news_id : Int, title : String, text : String}) {
        this.news.edit(args);
    }
}