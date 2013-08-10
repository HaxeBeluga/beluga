package beluga.core.module;
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
	
	public function _loadConfig(path : String) : Void {
//		var file = File.getContent(path);
		var xml = Xml.parse(path);
		var fast = new Fast(xml);
		loadConfig(fast);
	}
	
	//Would be better if ModuleImpl was declared abstract or equivalent
	//The method below should always be defined in ModuleImpl children and has nothing to do here :(
	public function loadConfig(data : Fast) {
	
	}
}