// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.CallStack;

import beluga.core.module.Module;

class ModuleLoader {

    private static var modules = new Map<String, Module>();

    //Need to be there since all loaded modules are referred here
    //Resolve both simple and full path
    public static function getModuleInstanceByName(name : String) : Module {
        var realClass = Type.resolveClass(name + "Impl");
        if (realClass == null)
            realClass = Type.resolveClass("beluga.module." + name.toLowerCase() + "." + name.substr(0, 1).toUpperCase() + name.substr(1).toLowerCase() + "Impl");
        if (realClass == null)
            throw new BelugaException("Module not found " + name);
        if (modules.exists(Type.getClassName(realClass))) {
            return cast modules.get(Type.getClassName((realClass)));
        }
        var instance = Type.createInstance(realClass, []);
        modules.set(Type.getClassName(realClass), instance);
        return instance;
    }

    public static function resolveModel(module : String, name : String) : Class<Dynamic> {
        var realClass = Type.resolveClass("beluga.module." + module + ".model." + name);
        if (realClass == null) {
            throw new BelugaException("Model not found " + name);
        }
        return realClass;
    }

    macro public static function init() : Expr {
        ConfigLoader.forceBuild();
        for (module in ConfigLoader.modules) {
            // Huge constraint :
            // The module is not compiled, which means that if it has a wrong syntax, it won't work without notification
            // Only the package is added to the compile unit
            Compiler.include(module.path, true, [module.path + ".js"]); //Provisional, issue #2100 https://github.com/HaxeFoundation/haxe/issues/2100
            //Compiler.addClassPath(module.path);
        }

        return Context.makeExpr("DONE!", Context.currentPos());
    }
}