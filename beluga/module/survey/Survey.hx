package beluga.module.survey;

import beluga.core.module.Module;

import beluga.module.survey.model.Choice;

interface Survey extends Module {
    public function canVote(args : {survey_id : Int}) : Bool;
    public function print(args : {survey_id : Int}) : Void;
    public function create(args : {
        title : String,
        description : String,
        choices : Array<String>
    }) : Void;
    public function vote(args : {
        survey_id : Int,
        option : Int
    }) : Void;
    public function getSurveysList() : Array<SurveyData>;
    public function redirect() : Void;
    public function delete(args : {survey_id : Int}) : Void;
    public function getChoices(args : {survey_id : Int}) : Array<Choice>;
    public function getResults(args : {survey_id : Int}) : Array<Dynamic>;
}