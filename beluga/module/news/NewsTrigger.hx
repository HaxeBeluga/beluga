package beluga.module.news;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class NewsTrigger {
    public var redirect = new TriggerVoid();
    public var redirectEdit = new Trigger<{news_id: Int}>();
    public var defaultNews = new TriggerVoid();
    public var print = new Trigger<{news_id: Int}>();
    public var editFail = new Trigger<{news_id: Int, error: String}>();
    public var editSuccess = new Trigger<{news_id: Int}>();
    public var addCommentFail = new Trigger<{news_id: Int, error: String}>();
    public var addCommentSuccess = new Trigger<{news_id: Int}>();
    public var deleteCommentFail = new Trigger<{news_id: Int, error: String}>();
    public var deleteCommentSuccess = new Trigger<{news_id: Int}>();
    public var deleteSuccess = new TriggerVoid();
    public var deleteFail = new TriggerVoid();
    public var createFail = new Trigger<{title: String, data: String, error: String}>();
    public var createSuccess = new TriggerVoid();

    public function new() {}
}