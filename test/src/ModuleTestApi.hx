package ;

import haxe.macro.Expr;
import haxe.web.Dispatch;

class ModuleTestApi
{
    public static var module_test_map = new Map <String, Dynamic>();

    macro public static function addModule(name : Expr, module : Expr) {
        return macro ModuleTestApi.module_test_map[${name}] = haxe.web.Dispatch.make(${module});
    }
    
}