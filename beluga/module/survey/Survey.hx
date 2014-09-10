package beluga.module.survey;

import beluga.core.module.Module;

import beluga.module.survey.model.Choice;
import beluga.module.survey.model.SurveyModel;

interface Survey extends Module {
    public var triggers: SurveyTrigger;

	#if (php || neko)
    public function canVote(args : {survey_id : Int}) : Bool;
    public function create(args : {
        title : String,
        description : String,
        choices : Array<String>
    }) : Void;
    public function vote(args : {
        survey_id : Int,
        option : Int
    }) : Void;
    public function getSurvey(survey_id: Int) : SurveyModel;
    public function getSurveysList() : Array<SurveyData>;
    public function delete(args : {survey_id : Int}) : Void;
    public function getChoices(args : {survey_id : Int}) : Array<Choice>;
	#end
    public function redirect() : Void;
    public function getResults(args : {survey_id : Int}) : Array<Dynamic>;
    public function print(args : {survey_id : Int}): Void;
}