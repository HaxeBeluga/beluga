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
		//Check if folder exists first, if not, compile error
		var tplFolder = ConfigLoader.installPath + "/module/" + module + "/src/tpl/";
		if (!FileSystem.exists(tplFolder)) {
			return "The module " + module + " does not exists or is bad formatted";
		}
		
		for (file in FileSystem.readDirectory(tplFolder)) {
			var filepath = tplFolder + file;
			if (FileSystem.exists(filepath) && !FileSystem.isDirectory(filepath)) {
				Context.addResource("beluga_" + module + "_" + file.split(".")[0], File.getBytes(filepath));
			}
		}
		return null;
	}

	macro public static function build() : Array<Field>
	{
		var pos = haxe.macro.Context.currentPos();
		var fields = haxe.macro.Context.getBuildFields();

		var clazz = Context.getLocalClass().get();

		var clazzTypePath = { sub: null, params: [], pack : [] , name : clazz.name };
		var clazzComplexType = TPath( clazzTypePath );
		var arrayType = macro : Map<String, $clazzComplexType>;

		//Generate instance static field
		fields.push( { name : "instance", doc : null, meta : [], access : [APrivate, AStatic], kind : FVar(arrayType, null), pos : pos } );

		var classDecl = {
			pos : Context.currentPos(),
			expr: ENew(clazzTypePath, [])
		};
		var bodyFunc = macro {
			if (instance == null) {
				instance = new Map<String, $clazzComplexType>();
			}
			if (!instance.exists(key)) {
				instance.set(key, ${classDecl}); 
			}
			return instance.get(key);
		};
		var fun : Function = {
			ret : clazzComplexType,
			params : [],
			expr : bodyFunc,
			args : 	[
						{name: "key", opt: false, value: macro "", type: macro : String}
					]
		};
		fields.push( { name : "getInstance", doc : null, meta : [], access : [APublic, AStatic], kind : FFun(fun), pos : pos } );
		
		//Unsafe argument
		var err = loadResources(clazz.module.split(".")[2]);
		
		if (err != null) {
			Context.error(err, Context.currentPos());
		}

        return fields;
	}
}