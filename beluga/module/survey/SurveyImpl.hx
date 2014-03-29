package beluga.module.survey;

import beluga.module.account.model.User;
import beluga.module.survey.model.Survey;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.SurveyInternal;
import beluga.module.account.Account;
import php.Lib;
import php.Web;
import php.Session;
import beluga.core.module.ModuleImpl;

class SurveyData
{
	var m_survey : beluga.module.account.model.Survey;
	var m_choices : Array<Choice>;
	var m_results : Array<Result>;
	
	public function new() {
		m_choices = new Array<Choice>;
		m_results = new Array<Result>;
		m_survey = null;
	}
}

class SurveyImpl extends ModuleImpl implements SurveyInternal {
	var m_surveys : Array<SurveyData>;
	var title : String;
	
	/*
	 * contructor takes Survey's name (if exists)
	 */
	public function new(title : String) {
		this.title = title;
		m_surveys = new Array<SurveyData>;
	}
	
	/*
	 * default constructor, in case you want to create a new Survey
	 */
	public function new() {
		this.title = "";
		m_surveys = new Array<SurveyData>;
	}
	
	/*
	 * before calling this method, you have to instantiate the class with the get method
	 * param : none
	 * returns the SurveyData list of the current user
	 */
	public function getSurveysList() : Array<SurveyData> {
		return m_surveys;
	}
	
	/*
	 * called to "instantiate" this class, based on the current User
	 * param : none
	 */
	public function get() {
		var user = Beluga.getModuleInstance(Account);
		
		m_surveys = new Array<SurveyData>;
		
		for (tmp in Survey.manager.search( { name : title, author : user } )) {
			var tmp_v = new SurveyData();
			
			tmp_v.survey = tmp;
			
			for (tmp in Choice.manager.search( { survey : survey } ))
				tmp_v.m_choices.push(tmp);
			for (tmp in Result.manager.search( { survey : survey, user : user } ))
				tmp_v.m_results.push(tmp);
				
			m_surveys.push(tmp_v);
		}
	}
	
	/*
	 * called to print the good file (it depends on the User's status : has voted or not
	 * param : Survey to print
	 */
	static public function print(survey : Survey) : String
	{
		var res = "";
		var user = Beluga.getModuleInstance(Account);

		survey.get();

		if (survey.exists() == false)
			res = "_create";
		else if (survey.canVote(user))
			res = "_vote";
		else
			res = "_print_survey";

		var str = haxe.Resource.getString(res);
		var t = new haxe.Template(str);

		return t.execute(survey);
	}
	
	/*
	 * called to create a nwew Survey (if doesn't exist)
	 * param : title (String), status (Int), description (String), choices (Array<String>)
	 */
	public function create(title : String, status : Int, description : String, choices : Array<String>) {
		if (user == null || choices.length < 2)
			return;
		
		var tmp_choices = new Array<String>;
		
		// this loop delete duplicate data
		for (tmp in choices) {
			tmp_choices.push(tmp);
			choices.remove(tmp);
		}
		if (tmp_choices.length < 2)
			return;
		
		m_user = user;
		
		var survey = new Survey;
		survey.name = title;
		survey.status = status;
		//survey.dateEnd = ;
		survey.author_id = user.id;
		survey.description = description;
		survey.multiple_choice = choices.length;
		
		survey.insert();
		for (tmp in tmp_choices) {
			var c = new Choice;
			
			c.label = tmp;
			c.survey_id = survey.id;
			c.insert();
		}
	}
	
	/*
	 * called when a User add a vote for a Survey
	 * params : String (choice's name), Survey (to know in which survey you add the vote)
	 */
	public function vote(choice : String, survey : beluga.module.account.model.Survey) {
		var user = Beluga.getModuleInstance(Account);

		if (m_surveys == null)
			this.get();

		var tmp_choice = null;
		for (tmp in Result.manager.search( { survey : survey, user : user } ))
			return;
		for (tmp in Choice.manager.search( { survey : survey } ))
			if (tmp.label == choice)
				tmp_choice = choice;
		if (tmp_choice == null)
			return;
		var res = new Result;

		res.survey_id = survey.id;
		res.user_id = user.id;
		res.choice_id = tmp_choice.id;
		res.insert();
	}
	
	/*
	 * return true if the User hasn't vote yet in this Survey
	 * param : User
	 */
	public function canVote(user : User) : Bool {
		for (tmp in m_surveys)
			for (tmp_tmp in tmp.m_results)
				if (tmp_tmp.user == user)
					return false;
		return true;
	}
	
	/*
	 * return the User choice (if exists) in this Survey
	 * param : User
	 */
	public function getVote(user : User) : beluga.module.survey.model.Choice {
		for (tmp in m_surveys)
			for (tmp_tmp in tmp.m_results)
				if (tmp_tmp.user == user)
					return tmp.choice;
		return null;
	}
	
	/*
	 * return true if survey exists in database, otherwise return false
	 * param : none
	 */
	public function exists() : Bool {
		return m_surveys.length > 0;
	}
}