package beluga.core.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import beluga.core.module.Module;
import haxe.macro.Compiler;

/**
 * ...
 * @author Masadow
 */
class ModuleLoader
{
	//Need to be there since all loaded modules are referred here
	//Resolve both simple and full path
	public static function getModuleInstanceByName(name : String, key : String = "") : Module {
		var realClass = Type.resolveClass(name + "Impl");
		if (realClass == null)
			realClass = Type.resolveClass("beluga.module." + name.toLowerCase() + "." + name.substr(0, 1).toUpperCase() + name.substr(1).toLowerCase() + "Impl");
		if (realClass == null)
			throw new BelugaException("Module not found " + name);
		return Reflect.field(realClass, "getInstance")(key);
	}

	public static function resolveModel(module : String, name : String) : Class<Dynamic> {
		var realClass = Type.resolveClass("beluga.module." + module + ".model." + name);
		if (realClass == null) {
			throw new BelugaException("Model not found " + name);
		}
		return realClass;
	}
	
	macro public static function init() : Expr
	{
		ConfigLoader.forceBuild();
		for (module in ConfigLoader.modules) {
			
			// Huge constraint :
			// The module is not compiled, which means that if it has a wrong syntax, it won't work without notification
			// Only the package is added to the compile unit
			Compiler.include(module.path); //Provisional, issue #2100 https://github.com/HaxeFoundation/haxe/issues/2100
			//Compiler.addClassPath(module.path);
		}
		return Context.makeExpr("DONE!", Context.currentPos());
	}
}