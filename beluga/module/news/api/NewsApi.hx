package beluga.module.news.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

import beluga.module.news.News;

class NewsApi {
    public var beluga : Beluga;
    public var module : News;

    public function new() {
    }

    public function doDefault() {
        this.module.triggers.defaultNews.dispatch();
    }

    public function doPrint(args : {news_id : Int}) {
    	this.module.triggers.print.dispatch(args);
    }

    public function doRedirect() {
    	this.module.triggers.redirect.dispatch();
    }

    public function doCreate(args : {title : String, text : String}) {
        this.module.create(args);
    }

    public function doDelete(args : {news_id : Int}) {
        this.module.delete(args);
    }

    public function doDeleteCom(args : {com_id : Int, news_id : Int}) {
        this.module.deleteComment({news_id : args.news_id, comment_id : args.com_id});
    }

    public function doCreateComment(args : {news_id : Int, text : String}) {
        this.module.addComment(args);
    }

    public function doEdit(args : {news_id : Int, title : String, text : String}) {
        this.module.edit(args);
    }

    public function doRedirectEdit(args : {news_id : Int}) {
    	this.module.triggers.redirectEdit.dispatch(args);
    }
}
