package beluga.core;
import beluga.core.macro.ConfigLoader;
import haxe.Resource;
import sys.io.File;

/**
 * ...
 * @author Masadow
 */
class Widget
{
	private static var last_id : Int;
	private static var available_resources = Resource.listNames();

	public var context : Dynamic;
	private var filecontent : String;
	private var id : Int;
	private var html : String;
	
	private var css : String;

	public function new(module : Null<String>, name : Null<String>)
	{
		if (module != null && name != null) {

			//Load template
			if (Lambda.has(available_resources, "beluga_" + module + "_" + name)) {
				filecontent = Resource.getString("beluga_" + module + "_" + name);
			} else {
				throw new BelugaException("The widget " + name + " does not exists");
			}
			
			if (Lambda.has(available_resources, "beluga_" + module + "_css_" + name)) {
				css = Resource.getString("beluga_" + module + "_css_" + name);
			} else {
				//No Css file provide put log warning
			}
				
		}
		context = { };
		id = 0;
		html = "";
	}
	
	//Once a widget is rendered, you can't modify it again.
	//If you want to this, you have to clone it (before or after first rendering)
	public function render() : String {
		if (id == 0) {
			var t = new haxe.Template(filecontent);
			context._id = ++last_id;
			id = context.id;
			if (ConfigLoader.config.hasNode.url && ConfigLoader.config.node.url.hasNode.base && ConfigLoader.config.node.url.node.base.has.value)
				context.base_url = ConfigLoader.config.node.url.node.base.att.value;
			else
				context.base_url = "";
			html = t.execute(context);
		}
		return html;
	}
	
	public function getId() : Int {
		return id;
	}

	public function clone() : Widget {
		var ret = new Widget(null, null);
		ret.filecontent = filecontent;
		ret.context = context;
		return ret;
	}
	
	public function getCss() : String {
		return css;
	}
}
