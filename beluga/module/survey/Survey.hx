// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey;

import beluga.core.module.Module;

import beluga.module.survey.model.Choice;
import beluga.module.survey.model.SurveyModel;
import beluga.module.survey.SurveyWidget;
import beluga.module.survey.SurveyTrigger;

interface Survey extends Module {
    public var triggers: SurveyTrigger;
    public var widgets : SurveyWidget;

    public function canVote(survey_id : Int) : Bool;
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
    public function redirect() : Void;
    public function delete(survey_id : Int) : Void;
    public function getChoices(survey_id : Int) : Array<Choice>;
    public function getResults(survey_id : Int) : Array<Dynamic>;
    public function print(survey_id : Int): Void;
    public function getActualSurveyId() : Int;
}