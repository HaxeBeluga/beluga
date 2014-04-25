package beluga.module.survey;

import beluga.module.account.model.User;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.SurveyInternal;
import beluga.module.account.Account;
import beluga.core.module.ModuleImpl;
import beluga.module.survey.SurveyData;
import beluga.module.survey.model.SurveyModel;
import beluga.core.Beluga;

import haxe.xml.Fast;

class SurveyImpl extends ModuleImpl implements SurveyInternal {

	public function new() {
		super();
	}
	
	override public function loadConfig(data : Fast) {
		
	}
	
	public static function _redirect() {
		Beluga.getInstance().getModuleInstance(Survey).redirect();
	}

	public function redirect() {
		beluga.triggerDispatcher.dispatch("beluga_survey_redirect", []);
	}

	public static function _delete(args : {id : Int}) {
		Beluga.getInstance().getModuleInstance(Survey).delete(args);
	}

	public function delete(args : {id : Int}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		var nb = 0;

		if (user == null)
			return;
		for (tmp in SurveyModel.manager.dynamicSearch( {author_id : user.id, id : args.id} )) {
			tmp.delete();
			nb += 1;
		}

		if (nb > 0) {
			beluga.triggerDispatcher.dispatch("beluga_survey_delete_success", []);
		} else {
			beluga.triggerDispatcher.dispatch("beluga_survey_delete_fail", []);
		}
	}

	public function getSurveysList() : Array<SurveyData> {

		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		var m_surveys = new Array<SurveyData>();

		if (user == null)
			return m_surveys;

		for (tmp in SurveyModel.manager.dynamicSearch( { author_id : user.id } )) {
			var tmp_v = new SurveyData();

			tmp_v.m_survey = tmp;
			
			for (tmp_c in Choice.manager.dynamicSearch( { survey_id : tmp.id } ))
				tmp_v.m_choices.push(tmp_c);
			for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } ))
				tmp_v.m_results.push(tmp_c);

			m_surveys.push(tmp_v);
		}
		return m_surveys;
	}

	public static function _print(args : {id : Int}) {
		Beluga.getInstance().getModuleInstance(Survey).print(args);
	}
	
	public function print(args : {id : Int}) {
		for (tmp in SurveyModel.manager.dynamicSearch( {id : args.id} )) {
			beluga.triggerDispatcher.dispatch("beluga_survey_printx", [{survey : tmp}]);
			return;
		}
	}

	public function getChoices(args : {id : Int}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		var arr = new Array<Choice>();

		if (user != null) {
			for (tmp in SurveyModel.manager.dynamicSearch( {id : args.id} )) {
				for (tmp_c in Choice.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } )) {
					arr.push(tmp_c);
				}
			}
		}
		return arr;
	}

	public static function _create(args : {
		title : String,
		description : String,
		choices : Array<String>
	}) {
		Beluga.getInstance().getModuleInstance(Survey).create(args);
	}
	
	public function create(args : {
		title : String,
		description : String,
		choices : Array<String>
	}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		
		if (user == null || args.choices == null || args.choices.length < 2 || args.title == "") {
			beluga.triggerDispatcher.dispatch("beluga_survey_create_fail", []);
			return;
		}
		
		var tmp_choices = new Array<String>();

		if (args.choices != null)
			for (t in args.choices)
				if (t != null && t != "")
					tmp_choices.push(t);

		if (tmp_choices.length < 2) {
			beluga.triggerDispatcher.dispatch("beluga_survey_create_fail", []);
			return;
		}

		var survey = new SurveyModel();

		survey.name = args.title;
		survey.author_id = user.id;
		survey.description = args.description;
		survey.multiple_choice = args.choices != null ? args.choices.length : 0;
		
		survey.insert();
		for (tmp in tmp_choices) {
			var c = new Choice();
			
			c.label = tmp;
			c.survey_id = survey.id;
			c.insert();
		}
		
		beluga.triggerDispatcher.dispatch("beluga_survey_create_success", []);
	}
	
	public static function _vote(args : {
		id : Int,
		option : Int
	}) {
		Beluga.getInstance().getModuleInstance(Survey).vote(args);
	}
	
	public function vote(args : {
		id : Int,
		option : Int
	}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		if (user == null) {
			this.redirect();
			return;
		}

		for (tmp in Result.manager.search( { survey_id : args.id, user_id : user.id } )) {
			beluga.triggerDispatcher.dispatch("beluga_survey_vote_fail", []);
			return;
		}

		var survey : SurveyModel;

		for (tmp in SurveyModel.manager.dynamicSearch( {id : args.id} ))
			survey = tmp;
		var res = new Result();

		res.survey_id = survey.id;
		res.user_id = user.id;
		res.choice_id = args.option;
		res.insert();
		
		var notify = {
			title: "New answer to your survey !",
			text: user.login + " has just answer to your survey " + survey.name + 
			" <a href=\"/beluga/survey/print?id=" + survey.id + "\">See</a>.",
			user_id: survey.author_id
		};

		beluga.triggerDispatcher.dispatch("beluga_survey_answer_notify", [notify]); 
		beluga.triggerDispatcher.dispatch("beluga_survey_vote_success", []);
	}
	

	public function canVote(args : {id : Int}) : Bool {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in SurveyModel.manager.dynamicSearch( {id : args.id} )) {
				for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } )) {
					return false;
				}
				return true;
			}
		}
		return false;
	}
}