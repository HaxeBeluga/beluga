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

import beluga.module.news.NewsErrorKind;

import sys.db.Types;

class NewsTrigger {
    public var redirect = new TriggerVoid();
    public var redirectEdit = new TriggerVoid();
    public var defaultNews = new TriggerVoid();
    public var print = new TriggerVoid();
    public var editFail = new Trigger<{error: NewsErrorKind}>();
    public var editSuccess = new TriggerVoid();
    public var addCommentFail = new Trigger<{error: NewsErrorKind}>();
    public var addCommentSuccess = new TriggerVoid();
    public var deleteCommentFail = new Trigger<{error: NewsErrorKind}>();
    public var deleteCommentSuccess = new TriggerVoid();
    public var deleteSuccess = new TriggerVoid();
    public var deleteFail = new Trigger<{error: NewsErrorKind}>();
    public var createFail = new Trigger<{error: NewsErrorKind}>();
    public var createSuccess = new TriggerVoid();

    public function new() {}
}