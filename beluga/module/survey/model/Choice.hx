package beluga.module.survey.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.survey.model.SurveyModel;

@:table("beluga_sur_choice")
@:id(id)
class Choice extends Object {
    public var id : SId;
    public var label : STinyText;
    public var survey_id : SInt;
    @:relation(survey_id) public var survey : SurveyModel;
}