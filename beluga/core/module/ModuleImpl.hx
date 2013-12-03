package beluga.core.module;
import beluga.core.BelugaException;
import beluga.core.Widget;
import haxe.Resource;
import haxe.xml.Fast;
import sys.io.File;

/**
 * ...
 * @author Masadow
 */
@:autoBuild(beluga.core.module.ModuleBuilder.build())
class ModuleImpl implements ModuleInternal
{
	
	public function new() : Void
	{
	}

	public function _loadConfig(config : String) : Void {
//		var file = File.getContent(path);
		var xml = Xml.parse(config);
		var fast = new Fast(xml);
		loadConfig(fast);
	}

	//Would be better if ModuleImpl was declared abstract or equivalent
	//The method below should always be defined in ModuleImpl children and has nothing to do here :(
	public function loadConfig(data : Fast) {
		throw new BelugaException("Missing implementation of loadConfig in module " + Type.getClassName(Type.getClass(this)));
	}
	
	
	public function getWidget(name : String) : Widget {
		//First retrieve the class path
		var module = Type.getClassName(Type.getClass(this)).split(".")[2];
		return new Widget(module + "_" + name);
	}
}