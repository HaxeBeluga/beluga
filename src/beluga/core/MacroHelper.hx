package beluga.core;

import haxe.Log;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
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

	//Need to be there since all loaded modules are referred here
	public static function getModuleInstanceByName(name : String, key : String = "") {
		var realClass = Type.resolveClass(name + "Impl");
		if (realClass == null)
			throw "Module not found " + name;
		return Reflect.callMethod(realClass, "getInstance", []);
	}

	macro public static function importConfig()
	{
		//Load configuration
		var file = File.getContent("beluga.xml"); //Problem, where should we put this configuration file ?
		var xml = Xml.parse(file);                    //Is it necessary to let user edit it without recompile its project ?
		var fast = new Fast(xml);
//		var moduleList = "";
		var modulesFile = new Array<{ field : String, expr : Expr }>();

		// Look for active modules
		for (module in xml.elements()) {
			if (module.nodeName == "module") {
				var name : String = module.get("name");
				var modulePath = fast.node.install.att.path + "/module/" + name.toLowerCase();
				var module = "beluga.module." + name.toLowerCase() + "." + name.substr(0, 1).toUpperCase() + name.substr(1) + "Impl";
				// Huge constraint :
				// The module is not compiled, which means that if it has a wrong syntax, it won't work without notification
				Compiler.addClassPath(module);

				//Build a list of modules config files
				modulesFile.push( { field: name.toLowerCase(), expr: Context.makeExpr(File.getContent(fast.node.install.att.path + "/module/" + name.toLowerCase() + "/config.xml"), Context.currentPos()) } );
				
				//For each module, compile all assets
				var templates = FileSystem.readDirectory(modulePath + "/src/tpl");

				if (!FileSystem.exists(Compiler.getOutput() + "/tpl")) //If output does not exist, create directory
					FileSystem.createDirectory(Compiler.getOutput() + "/tpl");
				for (template in templates) {
					
					//Switch to Sys.command ?
					var process = new Process(fast.node.install.node.templo.att.bin, [
						//Check target here (neko/php)
						"-php", modulePath + "/src/tpl/" + template,
						//"-cp", modulePath + "/src/tpl/" + template,
						//Output is assumed, maybe it should be in config ?
						"-output", Compiler.getOutput() + "/tpl"
					]);
					try {
						//while (true) //Will fail when buffer will be empty
//							Log.setColor(0xFF0000);
							Sys.stderr().writeString(process.stderr.readLine());
//						Compiler.
						//
					}
					catch (e : Dynamic) {
						
					}
					process.close();
				}
			}
		}

		var pos = Context.currentPos();

		var configExpr = Context.makeExpr(file, pos);
//		var modulesFileExpr = Context.makeExpr(modulesFile, pos);

//		var complexString : ComplexType = macro : String;
//		var complexListOfString : ComplexType = macro : Array<String>;

//		trace(moduleList);

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