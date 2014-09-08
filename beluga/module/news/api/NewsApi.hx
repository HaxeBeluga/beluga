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
        //module.triggers.defaultNews.dispatch();
    }
}
