package beluga.core.macro;

import sys.io.File;
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author Alexis Brissard
 */
class JsonTool
{
	#if macro
	public static function staticLoad(path : String) : Expr {
		var json = Json.parse(File.getContent(ConfigLoader.installPath+path));
		return Context.makeExpr(json, Context.currentPos());
	}
	#else
	macro public static function staticLoad(path : String) : Expr {
		return staticLoad(path);
	}
	#end

}