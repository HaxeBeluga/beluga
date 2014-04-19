package beluga.core.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

typedef ModuleConfig = { name : String, path : String, config : String, tables : Array<String> };

/**
 * ...
 * @author Masadow
 */
#if !macro
@:build(beluga.core.macro.ConfigLoader.build())
#end
class ConfigLoader
{
	private static var configFilePath = "beluga.xml";
	private static var built : Expr = null;

	public static var config(default, default) : Fast;
	public static var installPath(default, null) : String = getInstallPath();
	public static var modules(default, default) : Array<ModuleConfig>;

	//Read only property to check if the macro has been executed or not. Useless outside of the macro context
	public static var isReady(get, never) : Bool;
	public static function get_isReady() : Bool
	{
		#if macro
		return built != null;
		#else
		return true;
		#end
	}
	
	macro public static function build() : Array<Field>
	{
		var fields : Array<Field> = Context.getBuildFields();

		if (!isReady)
			built = loadConfig();

		//Fill the config variables for post-macro usage
		for (field in fields)
		{
			switch (field.kind)
			{
				case FProp(g, s, t, e):
					if (field.name == "config") {
						field.kind = FProp("get", "null", t, null);
					}
					else if (field.name == "modules")
						field.kind = FProp("default", "null", t, Context.makeExpr(modules, Context.currentPos()));
				default:
			}
		}
		
		fields.push( {
			pos: Context.currentPos(),
			name: "configStr",
			meta: [],
			kind: FVar(macro : String, macro $v{File.getContent(configFilePath)}),
			doc: null,
			access: [APrivate, AStatic]
		});

		return fields;
	}

	macro public static function forceBuild() : Expr
	{
		if (!isReady)
			built = loadConfig();
		return Context.makeExpr("DONE!", Context.currentPos());
	}

	//Used post macro for config prop
	#if !macro
	public static function get_config() : Fast
	{
		if (config == null)
		{
			var xml = Xml.parse(configStr);
			config = new Fast(xml);
		}
		return config;
	}
	#end

	private static function loopFiles(fast : Fast) {
		var config : String;
		var tables = new Array<String>();

		// Look for active modules
		for (module in fast.elements) {
			//Not fully supported, it can leads to mistakes
			//if (module.nodeName == "include") {
				//var path : String = module.get("path");
				//var vars = loopFiles(path, output);
				//modulesFile.concat(vars.modulesFile);
				//modules.concat(vars.modules);
				//file += vars.file;
			//}
			//else 
			if (module.name == "module") {
				var name : String = module.att.name;
				var modulePath = installPath + "/module/" + name.toLowerCase();
				var module : String = "beluga.module." + name.toLowerCase();// + "." + name.substr(0, 1).toUpperCase() + name.substr(1) + "Impl";


				//Build a list of modules config files
				config = File.getContent(installPath + "/module/" + name.toLowerCase() + "/config.xml");

				//Get every single models from the current module
				tables = new Array<String>();
				if (!FileSystem.isDirectory(modulePath + "/model")) {
					throw new BelugaException("Missing model directory from the module " + name);
				}
				else {
					for (model in FileSystem.readDirectory(modulePath + "/model")) {
						//Do not forget to remove the .hx extension to get the model name
						tables.push(model.substr(0, model.length - 3));
					}
				}

				modules.push({name: name, path: module, config: config, tables: tables});
			}
		}

		return {
			file : fast,
			modules : modules
		}
	}

	macro private static function loadConfig() : Expr
	{
		var pos = Context.currentPos();

		//Load configuration
		var file = File.getContent(configFilePath);
		var xml = Xml.parse(file);
		config = new Fast(xml);
		
		modules = new Array<ModuleConfig>();

		//Parse the configuration file
		var modulesInfo = loopFiles(config);
		
		return macro "DONE!";
	}

	macro private static function getInstallPath() : Expr {
		//Call "haxelib path beluga" to get the install path of beluga
		var bytepath = new sys.io.Process("haxelib", ["path", "beluga"]).stdout.readAll();

		var path = StringTools.trim(bytepath.readString(0, bytepath.length).split("\n")[0]);

		//Check the install path of Beluga
		if (path == "") {
			throw new BelugaException("Can't locate haxe installation folder. Make sure haxe is installed through haxelib and haxelib itself is installed properly.");
		}

		return Context.makeExpr(path + "/beluga", Context.currentPos());
	}
}