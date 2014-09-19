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
    public static function exprLoad(path : String) : Expr {
        var json = Json.parse(File.getContent(ConfigLoader.installPath+path));
        return Context.makeExpr(json, Context.currentPos());
    }

    public static function load(path : String) : Dynamic {
        return Json.parse(File.getContent(ConfigLoader.installPath+path));
    }
    #else
    macro public static function staticLoad(path : String) : Expr {
        return exprLoad(path);
    }
    #end

}