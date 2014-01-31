package beluga.module.survey;

/**
 * ...
 * @author Guillaume Gomez
 */

import sys.db.Object;
import sys.db.Types;
import beluga.module.survey.Survey;
import beluga.module.account.model.User;
import beluga.module.survey.Choice;

@:table("beluga_sur_result")
class Choice extends Object {
	public var survey_id : SInt;
	public var user_id : SInt;
	public var choice_id : SInt;
	@:relation(survey_id) public var survey : Survey;
	@:relation(user_id) public var user : User;
	@:relation(choice_id) public var choice : Choice;
}