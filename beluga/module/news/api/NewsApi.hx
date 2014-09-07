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
        module.triggers.defaultNews.dispatch();
    }

    public function doPrint(args : {news_id : Int}) {
        module.triggers.print.dispatch(args);
    }

    public function doCreate(args : {title : String, text : String}) {
        module.create(args);
    }

    public function doEdit(args : {news_id : Int, title : String, text : String}) {
        module.edit(args);
    }

    public function doDelete(args : {news_id : Int}) {
        module.delete(args);
    }

    public function doDeleteCom(args : {comment_id : Int, news_id : Int}) {
        module.deleteComment(args);
    }

    public function doRedirect() {
        module.triggers.redirect.dispatch();
    }

    public function doCreateComment(args : {news_id : Int, text : String}) {
        module.addComment(args);
    }

    public function doRedirectEdit(args : {news_id : Int}) {
        module.triggers.redirectEdit.dispatch(args);
    }
}
