package beluga.module.news.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.news.News;
import haxe.web.Dispatch;

class NewsApi
{
	public var beluga : Beluga;
	public var module : News;

    public function new() {
    }

	public function doDefault() {
		beluga.triggerDispatcher.dispatch("beluga_news_default", []);
	}

	public function doPrint(args : {news_id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_news_print", [args]);
	}

	public function doCreate(args : {title : String, text : String}) {
		beluga.triggerDispatcher.dispatch("beluga_news_create", [args]);
	}

	public function doEdit(args : {news_id : Int, title : String, text : String}) {
		beluga.triggerDispatcher.dispatch("beluga_news_edit", [args]);
	}

	public function doDelete(args : {news_id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_news_delete", [args]);
	}

	public function doDeleteCom(args : {com_id : Int, news_id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_news_deleteCom", [args]);
	}

	public function doRedirect() {
		beluga.triggerDispatcher.dispatch("beluga_news_redirect", []);
	}

	public function doCreateComment(args : {news_id : Int, text : String}) {
		beluga.triggerDispatcher.dispatch("beluga_news_createComment", []);
	}

	public function doRedirectEdit(args : {news_id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_news_redirectEdit", [args]);
	}
}
