package beluga.module.survey;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class SurveyTrigger {
    public var redirect = new TriggerVoid();
    public var deleteFail = new TriggerVoid();
    public var deleteSuccess = new TriggerVoid();
    public var printSurvey = new Trigger<{survey_id : Int}>();
    public var createFail = new TriggerVoid();
    public var createSuccess = new TriggerVoid();
    public var voteFail = new Trigger<{survey : Int}>();
    public var voteSuccess = new TriggerVoid();
    public var answerNotify = new Trigger<{title: String, text: String, user_id: SId}>();
    public var defaultSurvey = new TriggerVoid();

    public function new() {}
}