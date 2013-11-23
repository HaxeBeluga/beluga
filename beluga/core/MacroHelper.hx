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

/**
 * ...
 * @author Masadow
 */
class MacroHelper
{
	//Macro context only
	public static var installPath;

	//Need to be there since all loaded modules are referred here
	public static function getModuleInstanceByName(name : String, key : String = "") : Module{
		var realClass = Type.resolveClass(name + "Impl");
		if (realClass == null)
			throw "Module not found " + name;
		return Reflect.callMethod(realClass, "getInstance", [key]);
	}

	private static function loopFiles(filename : String, output : String) {

		//Load configuration
		var file = File.getContent(filename); //Problem, where should we put this configuration file ?
		var xml = Xml.parse(file);                    //Is it necessary to let user edit it without recompile its project ? Solution => haxe.Resource
		var fast = new Fast(xml);
//		var moduleList = "";
		var modulesFile = new Array<{ field : String, expr : String }>();
		var modules = new Array<String>();
		var installPath = fast.hasNode.install ? fast.node.install.att.path : "";

		// Look for active modules
		for (module in xml.elements()) {
			if (module.nodeName == "include") {
				var path : String = module.get("path");
				var vars = loopFiles(path, output);
				modulesFile.concat(vars.modulesFile);
				modules.concat(vars.modules);
				file += vars.file;
			}
			else if (module.nodeName == "module") {
				var name : String = module.get("name");
				var modulePath = installPath + "/module/" + name.toLowerCase();
				var module = "beluga.module." + name.toLowerCase();// + "." + name.substr(0, 1).toUpperCase() + name.substr(1) + "Impl";

				modules.push(module);
				
				//Build a list of modules config files
				modulesFile.push( { field: name.toLowerCase(), expr: File.getContent(installPath + "/module/" + name.toLowerCase() + "/config.xml") } );

				
				//OLD STUFF
				//For each module, compile all assets
				//var templates = FileSystem.readDirectory(modulePath + "/src/tpl");
//
				//if (!FileSystem.exists(output + "/tpl")) //If output does not exist, create directory
					//FileSystem.createDirectory(output + "/tpl");
				//for (template in templates) {
					//
					//Does it works since haxelib ???
					//Switch to Sys.command ?
					//var process = new Process(fast.node.install.node.templo.att.bin, [
						//Check target here (neko/php)
						//"-php", modulePath + "/src/tpl/" + template,
						//"-cp", modulePath + "/src/tpl/" + template,
						//Output is assumed, maybe it should be in config ?
						//"-output", output + "/tpl"
					//]);
					//try {
						//while (true) //Will fail when buffer will be empty
//							Log.setColor(0xFF0000);
							//Sys.stderr().writeString(process.stderr.readLine());
//						Compiler.
						//
					//}
					//catch (e : Dynamic) {
						//
					//}
					//process.close();
				//}
			}
		}

		return {
			file : file,
			modules : modules,
			modulesFile : modulesFile
		}
	}

	macro public static function importConfig()
	{
		var filename = "beluga.xml";
		var pos = Context.currentPos();

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
		MacroHelper.installPath = installPath;

		
		// Add the installation path of Beluga to haxe.Resource to make it globally accessible through macros
//		Context.addResource("beluga_installPath", Bytes.ofString(modulesInfo.installPath));
		
		for (module in modulesInfo.modules) {
			
			// Huge constraint :
			// The module is not compiled, which means that if it has a wrong syntax, it won't work without notification
			Compiler.include(module); //Provisional, issue #2100 https://github.com/HaxeFoundation/haxe/issues/2100
			Compiler.addClassPath(module);
		}

		var configExpr = Context.makeExpr(modulesInfo.file, pos);
		var modulesFile = new Array<{ field : String, expr : Expr }>();
		
		for (file in modulesInfo.modulesFile) {
			modulesFile.push( { field : file.field, expr : Context.makeExpr(file.expr, Context.currentPos()) } );
		}

		var e : Expr =  {
			expr : EObjectDecl([
				{
					field: "mainFile",
					expr: configExpr
				},
				{
					field: "module",
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

	//obsolete
	//Not working, should generate import statement in order to be able to resolve class module in getModuleInstance
	macro public static function importModule(module : String)
	{
//		Compiler.addClassPath(module);
//		Context.resolvePath(module);
		return Context.parse(module, Context.currentPos());
//		return haxe.macro.Context.makeExpr(null, Context.currentPos());
	}
	
}