package beluga.module.survey.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.survey.Survey;
import haxe.web.Dispatch;
import php.Web;

class SurveyApi 
{
	var beluga : Beluga;
	var survey : Survey;

	public function new(beluga : Beluga, survey : Survey) {
		this.beluga = beluga;
		this.survey = survey;
	}

	public function doCreate(args : {
		title : String,
		description : String,
		choices : String
	}) {
		var tmp = new Array<String>();
		var x = Web.getParams();
		x.remove("description");
		x.remove("title");

		for (t in x)
			tmp.push(t);

		beluga.triggerDispatcher.dispatch("beluga_survey_create", 
			[{title : args.title, description : args.description, choices : tmp}]);
	}

	public function doVote(args : {id : Int, option : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_survey_vote", [args]);
	}

	public function doPrint(args : {id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_survey_print", [args]);
	}

	public function doDefault() {
		beluga.triggerDispatcher.dispatch("beluga_survey_default", []);
	}

	public function doRedirect() {
		beluga.triggerDispatcher.dispatch("beluga_survey_redirect", []);
	}

	public function doDelete(args : {id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_survey_delete", [args]);
	}

}
