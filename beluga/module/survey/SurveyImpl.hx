package beluga.module.survey;

import beluga.module.account.model.User;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.SurveyInternal;
import beluga.module.account.Account;
import php.Lib;
import php.Web;
import php.Session;
import beluga.core.module.ModuleImpl;
import beluga.module.survey.SurveyData;
import beluga.module.survey.model.SurveyModel;
import beluga.core.Beluga;

import haxe.xml.Fast;

class SurveyImpl extends ModuleImpl implements SurveyInternal {
	var m_surveys : Array<SurveyData>;
	var title : String;
	
	/*
	 * contructor takes Survey's name (if exists)
	 */
	public function new() {
		super();
		this.title = "";
		m_surveys = new Array<SurveyData>();
		//this.get();
	}
	
	override public function loadConfig(data : Fast) {
		
	}

	/*
	 * before calling this method, you have to instantiate the class with the get method
	 * param : none
	 * returns the SurveyData list of the current user
	 */
	public function getSurveysList() : Array<SurveyData> {
		//this.get();
		return m_surveys;
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

	public static function _get() {
		Beluga.getInstance().getModuleInstance(Survey).get();
	}

	/*
	 * called to "instantiate" this class, based on the current User
	 * param : none
	 */
	public function get() {

		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null)
			return;

		m_surveys = new Array<SurveyData>();

		for (tmp in SurveyModel.manager.dynamicSearch( { author_id : user.id } )) {
			var tmp_v = new SurveyData();

			tmp_v.m_survey = tmp;
			
			for (tmp_c in Choice.manager.dynamicSearch( { survey_id : tmp.id } ))
				tmp_v.m_choices.push(tmp_c);
			for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } ))
				tmp_v.m_results.push(tmp_c);

			m_surveys.push(tmp_v);
		}
	}

	public static function _print(args : {id : Int}) {
		Beluga.getInstance().getModuleInstance(Survey).print(args);
	}
	
	public function print(args : {id : Int})
	{
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in SurveyModel.manager.dynamicSearch( {id : args.id} )) {
				for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } )) {
					beluga.triggerDispatcher.dispatch("beluga_survey_printx", [{survey : tmp}]);
					return;
				}
				beluga.triggerDispatcher.dispatch("beluga_survey_votex", [{survey : tmp}]);
				return;
			}
		}
		this.redirect();
	}

	public static function _create(args : {
		title : String,
		description : String,
		choices : Array<String>
	}) {
		Beluga.getInstance().getModuleInstance(Survey).create(args);
	}
	
	/*
	 * called to create a nwew Survey (if doesn't exist)
	 * param : title (String), status (Int), description (String), choices (Array<String>)
	 */
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
		
		// this loop delete duplicate data
		/*for (tmp in args.choices) {
			tmp_choices.push(tmp);
			args.choices.remove(tmp);
		}*/
		
		/*tmp_choices.push(args.choices);
		tmp_choices.push(args.choices2);*/
		if (args.choices != null)
			for (t in args.choices)
				if (t != null && t != "")
					tmp_choices.push(t);
		//tmp_choices.push(args.choices);

		if (tmp_choices.length < 2) {
			beluga.triggerDispatcher.dispatch("beluga_survey_create_fail", []);
			return;
		}

		var survey = new SurveyModel();

		survey.name = args.title;
		//survey.status = args.status;
		//survey.dateEnd = ;
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
		
		/*var str = haxe.Resource.getString(res);
		var t = new haxe.Template(str);*/
		
		beluga.triggerDispatcher.dispatch("beluga_survey_create_success", []);
	}
	
	public static function _vote(args : {
		id : Int,
		option : Int
	}) {
		Beluga.getInstance().getModuleInstance(Survey).vote(args);
	}
	
	/*
	 * called when a User add a vote for a Survey
	 * params : String (choice's name), Survey (to know in which survey you add the vote)
	 */
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
		
		beluga.triggerDispatcher.dispatch("beluga_survey_vote_success", []);
	}
	

	public function canVote(?user : User) : Bool {
		if (user == null)
			user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		for (tmp in m_surveys)
			for (tmp_tmp in tmp.m_results)
				if (tmp_tmp.user == user)
					return false;
		return true;
	}

	public function getVote(?user : User) : Array<beluga.module.survey.model.Choice> {
		if (user == null)
			user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		for (tmp in m_surveys)
			for (tmp_tmp in tmp.m_results)
				if (tmp_tmp.user == user)
					return tmp.m_choices;
		return null;
	}
}