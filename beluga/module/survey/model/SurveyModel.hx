package beluga.module.survey.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_sur_survey")
@:id(id)
class SurveyModel extends Object {
    public var id : SId;
    public var name : SString<128>;
    public var status : SInt;
    public var date_start : SDate;
    public var date_end : SDate;
    public var description : SText;
    public var author_id : SInt;
    public var multiple_choice : SBool; // true if the survey accepts multiple answer, false otherwise
    @:relation(author_id) public var author : User;
}