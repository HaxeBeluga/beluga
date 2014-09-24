// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.news;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class NewsTrigger {
    public var redirect = new TriggerVoid();
    public var redirectEdit = new Trigger<{news_id: Int}>();
    public var defaultNews = new TriggerVoid();
    public var print = new Trigger<{news_id: Int}>();
    public var editFail = new Trigger<{news_id: Int}>();
    public var editSuccess = new Trigger<{news_id: Int}>();
    public var addCommentFail = new Trigger<{news_id: Int}>();
    public var addCommentSuccess = new Trigger<{news_id: Int}>();
    public var deleteCommentFail = new Trigger<{news_id: Int}>();
    public var deleteCommentSuccess = new Trigger<{news_id: Int}>();
    public var deleteSuccess = new TriggerVoid();
    public var deleteFail = new Trigger<{news_id: Int}>();
    public var createFail = new TriggerVoid();
    public var createSuccess = new TriggerVoid();

    public function new() {}
}