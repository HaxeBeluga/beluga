package beluga.module.survey.model;

/**
 * ...
 * @author Guillaume Gomez
 */

import sys.db.Object;
import sys.db.Types;
import beluga.module.survey.model.SurveyModel;
import beluga.module.account.model.User;
//import beluga.module.survey.model.Choice;

@:table("beluga_sur_result")
class Result extends Object {
	public var id : SId;
	public var survey_id : SInt;
	public var user_id : SInt;
	public var choice_id : SInt;
	@:relation(survey_id) public var survey : SurveyModel;
	@:relation(user_id) public var user : User;
	@:relation(choice_id) public var choice : Choice;
}