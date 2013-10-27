package beluga.core;

import beluga.core.module.Module;
import beluga.core.module.ModuleInternal;
import haxe.xml.Fast;
import php.Web;
import sys.io.File;

//Enable or disable this line to check module compilations
/**import beluga.core.module.ManualBuildModule;/**/

/**
 * ...
 * @author Masadow
 */
class Beluga
{

	public var webDispatcher(default, null) : WebDispatcher;
	private var installPath : String;

	public function new()
	{
		webDispatcher = new WebDispatcher();

		//Load configuration
//		var file = File.getContent("beluga.xml"); //Problem, where should we put this configuration file ?
//		var xml = Xml.parse(file);                //Is it necessary to let user edit it without recompile its project ?
//		var fast = new Fast(xml);

		// Look for active modules
		var config = MacroHelper.importConfig();
		var xml = Xml.parse(config.mainFile);
		var fast = new Fast(xml);

		// Load beluga general configuration
		installPath = fast.node.install.att.path;

		// Look for triggers
		for (trigger in fast.nodes.trigger) {
			var trig = new Trigger(trigger);
			webDispatcher.register(trig);
		}

		for (module in fast.nodes.module) {
			var name : String = module.att.name;
			var module : ModuleInternal = cast MacroHelper.getModuleInstanceByName("beluga.module." + name.toLowerCase() + "." + name.substr(0, 1).toUpperCase() + name.substr(1).toLowerCase());
			if (Reflect.hasField(config.module, name.toLowerCase()))
				module._loadConfig(Reflect.field(config.module, name.toLowerCase()));
			else //Should handle exceptions
				trace("Warning: Missing configuration file for module " + name);
		}

		//Validate modules
		//Register modules
//		importModule("beluga.module.account.AccountImpl");

		//Connect to database
		if (fast.hasNode.database) {
			sys.db.Manager.initialize();
			var dbInfo = { host: "", user: "", pass: "", database: ""};
			for (elem in fast.node.database.elements) {
				Reflect.setField(dbInfo, elem.name, elem.innerHTML);
			}
			sys.db.Manager.cnx = sys.db.Mysql.connect(dbInfo);
		}
	}
	
	public function run(defaultTrigger : String = "index") {
		var trigger = Web.getParams().get("trigger");
		webDispatcher.dispatch(trigger != null ? trigger : defaultTrigger);
	}
	
	public function cleanup() {
		sys.db.Manager.cleanup();
	}
	
	public function getModuleInstance<T : Module>(clazz : Class<T>, key : String = "") : T
	{
		return cast MacroHelper.getModuleInstanceByName(Type.getClassName(clazz), key);
//		return T.getInstance();
	}
	
}