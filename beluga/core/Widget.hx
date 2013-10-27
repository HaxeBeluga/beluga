package beluga.core;
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
	
	public function new(resource : Null<String>)
	{
		if (resource != null) {
			if (Lambda.has(available_resources, "beluga_" + resource))
				filecontent = Resource.getString("beluga_" + resource);
			else
				throw new BelugaException("The widget " + resource + " does not exists");
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
			html = t.execute(context);
		}
		return html;
	}
	
	public function getId() : Int {
		return id;
	}

	public function clone() : Widget {
		var ret = new Widget("");
		ret.filecontent = filecontent;
		ret.context = context;
		return ret;
	}
}
