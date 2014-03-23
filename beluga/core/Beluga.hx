package beluga.core;

import beluga.core.module.Module;
import beluga.core.module.ModuleInternal;
import haxe.Resource;
import haxe.xml.Fast;
import php.Web;
import sys.io.File;
import beluga.core.Database;
import beluga.core.api.BelugaApi;
import beluga.core.macro.ConfigLoader;
import beluga.core.macro.ModuleLoader;

//Enable or disable this line to check module compilations
/**import beluga.core.module.ManualBuildModule;/**/

/**
 * ...
 * @author Masadow
 */
class Beluga
{

	//No singleton pattern allows multiple instance of Beluga
	public var triggerDispatcher(default, null) : TriggerDispatcher;
	// Keep an instance of beluga's database, read only
	public var db(default, null) : Database;
	//Instance of beluga API, read only
	public var api : BelugaApi;

	private static var instance = null;

	public static function getInstance() : Beluga {
		if (instance == null) {
			instance = new Beluga();
		}
		return instance;
	}

	private function new()
	{
		ModuleLoader.init();
		
		triggerDispatcher = new TriggerDispatcher();

		db = null;
		//Connect to database
		if (ConfigLoader.config.hasNode.database) {
			db = new Database(ConfigLoader.config.node.database.elements);
		}

		// Look for triggers
		for (trigger in ConfigLoader.config.nodes.trigger) {
			var trig = new Trigger(trigger);
			triggerDispatcher.register(trig);
		}

		//Init every modules
		for (module in ConfigLoader.modules) {
			var moduleInstance : ModuleInternal = cast ModuleLoader.getModuleInstanceByName(module.name);
			if (moduleInstance != null) {
				moduleInstance._loadConfig(this, module);
			}
		}
		
		//Create beluga API
		api = new BelugaApi(this);
	}
	
	public function dispatch(defaultTrigger : String = "index") {
		var trigger = Web.getParams().get("trigger");
		triggerDispatcher.dispatch(trigger != null ? trigger : defaultTrigger);
	}
	
	public function cleanup() {
		db.close();
	}

	public function getModuleInstance<T : Module>(clazz : Class<T>, key : String = "") : T
	{
		return cast ModuleLoader.getModuleInstanceByName(Type.getClassName(clazz), key);
//		return T.getInstance();
	}
	
}