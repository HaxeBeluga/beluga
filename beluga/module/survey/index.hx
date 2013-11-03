import php.Lib;
import php.Web;
import php.Session;

class Choice {
	public var name : String;
	public var vote : Int;
	public var pourcent : Float;
	
	public function new(n, v) {
		this.name = n;
		this.vote = v;
		this.pourcent = 0;
	}
}

class Survey {
	var title : String;
	var choices : Array<Choice>;
	var total : Int;
	
	public function new(t) {
		this.title = t;
		choices = new Array();
		total = 0;
	}
	
	public function addNewChoice(c) {
		choices.push(c);
		total += c.vote;
		this.remakePourcents();
	}
	
	public function addChoice(n, vote = 0) {
        choices.push(new Choice(n, vote));
		total += vote;
		this.remakePourcents();
    }
	
	public function addVote(name : String) {
		var done = "0";
		
		for (tmp in choices) {
			if (tmp.name == name) {
				tmp.vote = tmp.vote + 1;
				done = "1";
			}
		}
		if (done == "1") {
			this.total = this.total + 1;
			this.remakePourcents();
		}
	}
	
	private function remakePourcents() {
		for (tmp in choices) {
			if (total > 0) {
				tmp.pourcent = tmp.vote * 100 / total;
			}
			else {
				tmp.pourcent = 0;
			}
		}
	}
}

class Index
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
		
		/* all this part is for demonstration while waiting for database */
		for (tmp in form.values) {
			s.addChoice(tmp);
		}
		
		Session.set("survey", s);
		Session.set("answer", false);
		
		var str = haxe.Resource.getString("my_vote");
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
		
			var str = haxe.Resource.getString("my_print_survey");
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
		var output = haxe.Resource.getString("my_create");
		
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
}