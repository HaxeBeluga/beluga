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
		var context = getContext();
        return template.execute(context);
	}

	private function getContext() {
		return { };
	}
	
}