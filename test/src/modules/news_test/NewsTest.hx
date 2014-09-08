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
import haxe.CallStack;

#if php
import php.Web;
#end

class NewsTest implements MetadataReader {
    public var beluga(default, null) : Beluga;
    public var news(default, null) : News;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.news = beluga.getModuleInstance(News);
        this.news.triggers.defaultNews.add(this.doDefault);
        this.news.triggers.print.add(this.doPrint);
        this.news.triggers.redirect.add(this.doRedirect);
        this.news.triggers.redirectEdit.add(this.doRedirectEdit);
        this.news.triggers.deleteCommentFail.add(this.doPrint);
        this.news.triggers.deleteCommentSuccess.add(this.doPrint);
        this.news.triggers.createSuccess.add(this.doDefault);
        this.news.triggers.createFail.add(this.doRedirect);
        this.news.triggers.editSuccess.add(this.doPrint);
        this.news.triggers.editFail.add(this.doRedirectEdit);
        this.news.triggers.addCommentSuccess.add(this.doPrint);
        this.news.triggers.addCommentFail.add(this.doPrint);
        this.news.triggers.deleteSuccess.add(this.doDefault);
        this.news.triggers.deleteFail.add(this.doPrint);
    }

    public function doDefault() {
        var widget = news.getWidget("news");
        
        widget.context = news.getDefaultContext();
        var html = Renderer.renderDefault("page_news", "News list", {
            newsWidget: widget.render()
        });
        Sys.print(html);
    }

    /// FIXME : Check why page is generated twice
    public function doPrint(args : {news_id : Int}) {
        if (!news.canPrint(args.news_id)) {
            doDefault();
        } else {
            var widget = this.news.getWidget("print");
            
            widget.context = news.getPrintContext(args.news_id);
            var html = Renderer.renderDefault("page_news", "News", {
                newsWidget: widget.render()
            });
            Sys.print(html);
        }
    }

    public function doRedirect() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            doDefault();
            return;
        }
        var widget = news.getWidget("create");

        widget.context = news.getCreateContext();
        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doRedirectEdit(args : {news_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        
        if (user == null) {
            doDefault();
            return;
        }
        if (!news.canEdit(args.news_id, user.id)) {
            doPrint(args);
        } else {
            var widget = news.getWidget("edit");
            
            widget.context = news.getEditContext(args.news_id);
            Sys.print(Renderer.renderDefault("page_news", "Create news", {
                newsWidget: widget.render()
            }));
        }
    }

    public function doCreate(args : {title : String, text : String}) {
        this.news.create(args);
    }

    public function doDelete(args : {news_id : Int}) {
        this.news.delete(args);
    }

    public function doDeleteCom(args : {com_id : Int, news_id : Int}) {
        this.news.deleteComment({news_id : args.news_id, comment_id : args.com_id});
    }

    public function doCreateComment(args : {news_id : Int, text : String}) {
        this.news.addComment(args);
    }

    public function doEdit(args : {news_id : Int, title : String, text : String}) {
        this.news.edit(args);
    }
}