package core.form;
import php.Web;

/**
 * Missing:
	 * Equal to a certain value
	 * 
 */
enum Rule {
	Required; //Field is required
	Min(x : Int); //Minimum value
	Max(x : Int); //Maximum value
	Equal(field : String); //Should be equal to specified field
	Match(pattern : EReg); //Regex pattern
}

enum Method {
	Get;
	Post;
}

/**
 * ...
 * @author Masadow
 */
class Form
{

	private var rules : Map<String, Rule>;
	private var method : Method;
	public var errors : Map<String, Rule>;
	
	public function new(method : Method = Get)
	{
		rules = new Map<String, Rule>();
		errors = new Map<String, Rule>();
		this.method = method; //Useless ?
	}
	
	public function addRule(field : String, rule : Rule) {
		rules.set(field, rule);
	}
	
	private function value(field : String) : String {
		//PHP only
		return Web.getParamValues()[field];
	}
	
	public function validate() : Bool {
		for (field in rules.keys()) {
			var rule : Rule = rules[field];
			var value = value(field);
			
			//If a Required error was raised, we should not go further
			if (errors[field] == Required)
				continue ;
			
			switch (rule) { //Reminder: break; statement not needed with enums
				case Required:
					if (value == null)
						errors.set(field, rule);
				case Min(x):
				case Max(x):
				case Equal(field):
				case Match(pattern):
			}
		}
		return !errors.iterator().hasNext();
	}

}