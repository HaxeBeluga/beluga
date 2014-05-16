package beluga.core;

import beluga.core.macro.Metadata;
import beluga.core.module.Module;
import beluga.core.module.ModuleInternal;
import haxe.Resource;
import haxe.xml.Fast;
import sys.io.File;
import beluga.core.Database;
import beluga.core.api.BelugaApi;
import beluga.core.macro.ConfigLoader;
import beluga.core.macro.ModuleLoader;
import sys.FileSystem;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

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

	#if neko
	private function new(handleSessionPath : Bool = true)
	#else
	private function new()
	#end
	{
		#if neko
		if (handleSessionPath)
		{
			FileSystem.createDirectory(Web.getCwd() + "/temp");
			FileSystem.createDirectory(Web.getCwd() + "/temp/sessions");
		}
		#end
		
		ModuleLoader.init();
		triggerDispatcher = new TriggerDispatcher();

		db = null;
		//Connect to database
		if (ConfigLoader.config.hasNode.database) {
			db = new Database(ConfigLoader.config.node.database.elements);
		}

		// Look for triggers
		for (trigger in ConfigLoader.config.nodes.trigger) {
			triggerDispatcher.addRoutesFromFast(trigger);
		}
		for (meta in Metadata.getStaticMetadatas())
			if (meta.name == "blg_trigger")
				triggerDispatcher.addRoute(meta.params[0], meta.clazz, meta.method);
		
		//Init every modules
		for (module in ConfigLoader.modules) {
			var moduleInstance : ModuleInternal = cast ModuleLoader.getModuleInstanceByName(module.name);
			if (moduleInstance != null) {
				moduleInstance._loadConfig(this, module);
			}
		}
		
		//Create beluga API
		api = new BelugaApi();
		api.beluga = this;
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
	}
	
	public function getDispatchUri() : String
	{
		#if php
		//Get the index file location
		var src : String = untyped __var__('_SERVER', 'SCRIPT_NAME');
		//Remove server subfolders from URI
		return StringTools.replace(Web.getURI(), src.substr(0, src.length - "/index.php".length), "");
		#elseif neko
		return Web.getURI();
		#end
	}
}