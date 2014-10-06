// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey;

import sys.db.Types;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import beluga.module.survey.SurveyErrorKind;

class SurveyTrigger {
    public var redirect = new TriggerVoid();
    public var deleteFail = new Trigger<{error : SurveyErrorKind}>();
    public var deleteSuccess = new TriggerVoid();
    public var printSurvey = new TriggerVoid();
    public var createFail = new Trigger<{error : SurveyErrorKind}>();
    public var createSuccess = new TriggerVoid();
    public var voteFail = new Trigger<{error : SurveyErrorKind}>();
    public var voteSuccess = new TriggerVoid();
    public var answerNotify = new Trigger<{title: String, text: String, user_id: SId}>();
    public var defaultSurvey = new TriggerVoid();

    public function new() {}
}