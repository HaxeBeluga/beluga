package beluga.module.survey;

/**
 * ...
 * @author Guillaume Gomez
 */

import beluga.module.account.model.User;
import sys.db.Object;
import sys.db.Types;

@:table("beluga_sur_survey")
@:id(id)
class Survey extends Object {
	public var id : SId;
	public var name : SString<128>;
	public var status : SInt;
	public var date_start : SDate;
	public var date_end : SDate;
	public var description : SText;
	public var author_id : SInt;
	public var multiple_choice : STinyInt;
	@:relation(author_id) public var author : User;
}