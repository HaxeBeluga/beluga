package beluga.core.widget;

import haxe.Template;
import haxe.Resource;

/**
 * ...
 * @author brissa_A
 */
class MttWidget implements Widget
{

	private static var id = 0;
	private var template : Template;

	public function new(mttfile : String) 
	{
		var templateFileContent = Resource.getString(mttfile);
		template = new haxe.Template(templateFileContent);
	}
	
	public function render() : String {
        return template.execute( getContext(), getMacro());
	}

	private static function getI18n(resolve : String -> Dynamic, obj:Dynamic, lang : String, key : String) { 
		var f = Reflect.field;
		var text = f(f(obj, lang), key);
		if (text == null) text = "key " + key + "does not exist for lang " + lang;
        return text;
    }
	
	private function getContext() {
		return { };
	}
	
	private function getMacro() {
		return {};
	}
	
}