package beluga.core.module;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
import beluga.core.macro.ConfigLoader;

/**
 * ...
 * @author Masadow
 */
class ModuleBuilder
{
	//Load assets and src files
	private static function loadResources(module : String) : Null<String> {
		loadHtmlResources(module);
		loadCssResources(module);
		return null;
	}
	
	private static function loadCssResources(module : String) {
		//Check if folder exists first, if not, compile error
		var cssFolder = ConfigLoader.installPath + "/module/" + module + "/view/css/";
		if (!FileSystem.exists(cssFolder)) {
			return "The module " + module + " does not exists or is bad formatted";
		}
		
		for (file in FileSystem.readDirectory(cssFolder)) {
			var filepath = cssFolder + file;
			if (FileSystem.exists(filepath) && !FileSystem.isDirectory(filepath)) {
				Context.addResource("beluga_" + module + "_" + file, File.getBytes(filepath));
			}
		}
		return null;		
	}

	private static function loadHtmlResources(module : String) {
		//Check if folder exists first, if not, compile error
		var tplFolder = ConfigLoader.installPath + "/module/" + module + "/view/tpl/";
		if (!FileSystem.exists(tplFolder)) {
			return "The module " + module + " does not exists or is bad formatted";
		}
		
		for (file in FileSystem.readDirectory(tplFolder)) {
			var filepath = tplFolder + file;
			if (FileSystem.exists(filepath) && !FileSystem.isDirectory(filepath)) {
				Context.addResource("beluga_" + module + "_" + file, File.getBytes(filepath));
			}
		}
		return null;		
	}

	macro public static function build() : Array<Field>
	{
		var pos = haxe.macro.Context.currentPos();
		var fields = haxe.macro.Context.getBuildFields();

		var clazz = Context.getLocalClass().get();

		//Unsafe argument
		var err = loadResources(clazz.module.split(".")[2]);
		
		if (err != null) {
			Context.error(err, Context.currentPos());
		}

        return fields;
	}
}