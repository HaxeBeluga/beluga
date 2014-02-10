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

class SurveyImpl extends ModuleImpl implements SurveyInternal {
	var survey : beluga.module.account.model.Survey;
	var m_choices : Array<Choice>;
	var m_results : Array<Result>;
	var title : String;
	
	/*
	 * contructor takes Survey's name (if exists)
	 */
	public function new(title : String) {
		survey = null;
		m_choices = new Array<Choice>;
		m_results = new Array<Result>;
		this.title = title;
	}
	
	/*
	 * default constructor, in case you want to create a new Survey
	 */
	public function new() {
		survey = null;
		m_choices = new Array<Choice>;
		m_results = new Array<Result>;
		this.title = "";
	}
	
	/*
	 * called to "instantiate" this class, based on the current User
	 * param : none
	 */
	public function get() {
		var user = Beluga.getModuleInstance(Account);
		for (tmp in Survey.manager.search( { name : title, author : user } ))
			survey = tmp;
		if (survey == null)
			return;
		for (tmp in Choice.manager.search( { survey : survey } ))
			m_choices.push(tmp);
		for (tmp in Result.manager.search( { survey : survey, user : user } ))
			m_results.push(tmp);
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
		if (user == null || choices.length == 0)
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
		for (tmp in choices) {
			var c = new Choice;
			
			c.label = tmp;
			c.survey_id = survey.id;
			c.insert();
		}
	}
	
	/*
	 * called when a User add a vote for a Survey
	 * param : String (choice's title)
	 */
	public function vote(choice : String) {
		var user = Beluga.getModuleInstance(Account);
		if (survey == null)
			return;
		if (m_results.length == 0 || m_choices.length == 0)
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
		for (tmp in m_results)
			if (tmp.user == user)
				return false;
		return true;
	}
	
	/*
	 * return the User choice (if exists) in this Survey
	 * param : User
	 */
	public function getVote(user : User) : beluga.module.survey.model.Choice {
		for (tmp in m_results)
			if (tmp.user == user)
				return tmp.choice;
		return null;
	}
	
	/*
	 * return true if survey exists in database, otherwise return false
	 * param : none
	 */
	public function exists() : Bool {
		return survey != null;
	}
}

/*class Index
{
	static function main() {
		Session.start();
		var session = Lib.hashOfAssociativeArray(untyped __var__('_SESSION'));

		if (session.get("survey") != null) {
			printSurvey(Web.getParams());
		}
		else {
			var form = new Form();
			if (form.check(Web.getParams()) == "1") {
				printSurveyVote(new Form());
			}
			else {
				printSurveyBuilder();
			}
		}
	}
	
	static function printSurveyVote(form : Form) {
		var s = new Survey(form.title);
		var t = form.values.length;
		
		// all this part is for demonstration while waiting for database
		for (tmp in form.values) {
			s.addChoice(tmp);
		}
		
		Session.set("survey", s);
		Session.set("answer", false);
		
		var str = haxe.Resource.getString("_vote");
		var t = new haxe.Template(str);
		var output = t.execute(s);
		
		#if neko
        neko.Lib.print(output);
        #else
        php.Lib.print(output);
        #end
	}
	
	static function printSurvey(params : Map<String, String>) {
		var s = Session.get("survey");

		if (params.exists(s.title)) {
			s.addVote(params.get(s.title));
		
			var str = haxe.Resource.getString("_print_survey");
			var t = new haxe.Template(str);
			var output = t.execute(s);
			
			trace(params);
			#if neko
			neko.Lib.print(output);
			#else
			php.Lib.print(output);
			#end
		}
		else {
			var form = new Form();

			form.check(Web.getParams());
			printSurveyVote(form);
		}
	}
	
	static function printSurveyBuilder() {
		var output = haxe.Resource.getString("_create");
		
		#if neko
        neko.Lib.print(output);
        #else
        php.Lib.print(output);
        #end
	}
}

class Form
{
	public var title : String;
	public var values : Array<String>;
	
	public function new() {
		values = new Array();
    }
	
    public function check(params : Map<String, String>){
        var ret = '';
        
		if (params.exists('name')){
            this.title = params.get('name');
			
			for (tmp in params) {
				if (tmp != "")
					this.values.push(tmp);
			}
			this.values.remove(title);
			
			if (this.title == "" || this.values.length < 2)
				return "0";
			return "1";
        }
		return "0";
    }
}*/