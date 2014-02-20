package beluga.core;

import beluga.core.module.Module;
import haxe.io.Bytes;
import haxe.Log;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Resource;
import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

typedef ModuleConfig = { name : String, path : String, config : String, tables : Array<String> };

/**
 * ...
 * @author Masadow
 */
class MacroHelper
{
	//Macro context only
	public static var installPath;
	// Keep a list of modules to use it in other macros context
	public static var modulesArray : Array<String> = new Array<String>();

	//Need to be there since all loaded modules are referred here
	//Resolve both simple and full path
	public static function getModuleInstanceByName(name : String, key : String = "") : Module {
		var realClass = Type.resolveClass(name + "Impl");
		if (realClass == null)
			realClass = Type.resolveClass("beluga.module." + name.toLowerCase() + "." + name.substr(0, 1).toUpperCase() + name.substr(1).toLowerCase() + "Impl");
		if (realClass == null)
			throw new BelugaException("Module not found " + name);
		return Reflect.callMethod(realClass, "getInstance", [key]);
	}

	public static function resolveModel(module : String, name : String) : Class<Dynamic> {
		var realClass = Type.resolveClass("beluga.module." + module + ".model." + name);
		if (realClass == null) {
			throw new BelugaException("Model not found " + name);
		}
		return realClass;
	}

	private static function loopFiles(filename : String, output : String) {


		//Load configuration
		var file = File.getContent(filename); //Problem, where should we put this configuration file ?
		var xml = Xml.parse(file);            //Is it necessary to let user edit it without recompile its project ? Solution => haxe.Resource
		var fast = new Fast(xml);
		var config : String;
		var modules = new Array<ModuleConfig>();
		var tables = new Array<String>();

		// Look for active modules
		for (module in xml.elements()) {
			//Not fully supported, it can leads to mistakes
			//if (module.nodeName == "include") {
				//var path : String = module.get("path");
				//var vars = loopFiles(path, output);
				//modulesFile.concat(vars.modulesFile);
				//modules.concat(vars.modules);
				//file += vars.file;
			//}
			//else 
			if (module.nodeName == "module") {
				var name : String = module.get("name");
				var modulePath = MacroHelper.installPath + "/module/" + name.toLowerCase();
				var module : String = "beluga.module." + name.toLowerCase();// + "." + name.substr(0, 1).toUpperCase() + name.substr(1) + "Impl";


				//Build a list of modules config files
				config = File.getContent(MacroHelper.installPath + "/module/" + name.toLowerCase() + "/config.xml");

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

				modulesArray.push(name);
				modules.push({name: name, path: module, config: config, tables: tables});
			}
		}

		return {
			file : file,
			modules : modules
		}
	}
	
	private static function findBelugaPath() {
		//Call "haxelib path beluga" to get the install path of beluga
		var bytepath = new sys.io.Process("haxelib", ["path", "beluga"]).stdout.readAll();

		var path = StringTools.trim(bytepath.readString(0, bytepath.length).split("\n")[0]);

		return path + "/beluga";
	}

	macro public static function importConfig()
	{
		var filename = "beluga.xml";
		var pos = Context.currentPos();

		//Find the installPath of beluga
		MacroHelper.installPath = findBelugaPath();
		if (MacroHelper.installPath == "") {
			throw new BelugaException("Can't locate haxe installation folder. Make sure HAXE_HOME is set in your env");
		}

		var modulesInfo = loopFiles(filename, Compiler.getOutput());

		//Load configuration
		var file = File.getContent(filename); //Problem, where should we put this configuration file ?
		var xml = Xml.parse(file);                    //Is it necessary to let user edit it without recompile its project ?
		var fast = new Fast(xml);
		var installPath = fast.hasNode.install ? fast.node.install.att.path : "";

		//Add the install path of Beluga to the haxe.Resource to make it globally accessible through macros
		//Not true anymore, it is not accessible through macros, need to be deleted but actually used somewhere else
		//Should add the config file itself instead
		Context.addResource("beluga_config.xml", Bytes.ofString(file)); //Configuration remains accessible and editable

		for (module in modulesInfo.modules) {

			// Huge constraint :
			// The module is not compiled, which means that if it has a wrong syntax, it won't work without notification
			// Only the package is added to the compile unit
			Compiler.include(module.path); //Provisional, issue #2100 https://github.com/HaxeFoundation/haxe/issues/2100
			Compiler.addClassPath(module.path);
		}

		var configExpr = Context.makeExpr(modulesInfo.file, pos);
		var modulesFile = new Array<{ field : String, expr : Expr }>();

		for (module in modulesInfo.modules) {
			var fields = new Array<{field: String, expr: Expr}>();
			for (fieldName in Reflect.fields(module)) {
				fields.push( {
					field: fieldName,
					expr: Context.makeExpr(Reflect.field(module, fieldName), pos)
				});
			}
			modulesFile.push({
				field : module.name,
				expr : { pos: pos, expr: EObjectDecl(fields)}
			});
		}

		var e : Expr =  {
			expr : EObjectDecl([
				{
					field: "modules",
					expr: { expr: EObjectDecl(modulesFile), pos:pos}
				}
			]),
			pos: pos
		}

		return e;

		//Wait for a haxe compiler fix before using one of the line below
//		var anon = { config: file, modules: modulesFile };
//		return macro $e{anon};
//		return macro $e(anon);
		
		//Dead code ???
//		if (moduleList == "") {
//			Sys.stderr().writeString("Warning: You have not enable any module");
//			return macro {};
//		}
//		return Context.parse(moduleList, Context.currentPos());
	}	
}