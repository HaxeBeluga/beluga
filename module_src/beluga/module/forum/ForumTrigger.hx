// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum;

import beluga.trigger.Trigger;
import beluga.trigger.TriggerVoid;

import beluga.module.forum.ForumErrorKind;

import sys.db.Types;

class ForumTrigger {
    public var createCategoryFail = new Trigger<{error: ForumErrorKind}>();
    public var createCategorySuccess = new TriggerVoid();
    public var createTopicFail = new Trigger<{error: ForumErrorKind}>();
    public var createTopicSuccess = new TriggerVoid();
    public var postMessageFail = new Trigger<{error: ForumErrorKind}>();
    public var postMessageSuccess = new TriggerVoid();
    public var solveTopicFail = new Trigger<{error: ForumErrorKind}>();
    public var solveTopicSuccess = new TriggerVoid();
    public var deleteTopicFail = new Trigger<{error: ForumErrorKind}>();
    public var deleteTopicSuccess = new TriggerVoid();
    public var deleteCategoryFail = new Trigger<{error: ForumErrorKind}>();
    public var deleteCategorySuccess = new TriggerVoid();
    public var editCategoryFail = new Trigger<{error: ForumErrorKind}>();
    public var editCategorySuccess = new TriggerVoid();
    public var editMessageFail = new Trigger<{error: ForumErrorKind}>();
    public var editMessageSuccess = new TriggerVoid();
    public var moveTopicFail = new Trigger<{error: ForumErrorKind}>();
    public var moveTopicSuccess = new TriggerVoid();
    public var defaultForum = new TriggerVoid();

    public function new() {}
}