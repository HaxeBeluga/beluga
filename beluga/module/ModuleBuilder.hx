// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module ;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.MacroStringTools;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
import beluga.macro.ConfigLoader;

typedef ModuleEntry = {
    type : TypePath,
    ident: Expr
};

class ModuleBuilder
{
    private static var moduleClassTypeList : Array<ClassType> = new Array<ClassType>();

    macro public static function registerModule() : Array<Field> {
        var clazz = Context.getLocalClass().get();
        moduleClassTypeList.push(clazz);
        Sys.println("Module " + clazz.name + " loaded");
        return Context.getBuildFields();
    }
    
    macro public static function createInstances() : Expr {
        var expr = new Array<Expr>();
        for (clazz in moduleClassTypeList) {
            var classtype : TypePath = {
                sub: null,
                params: [],
                pack: clazz.pack,
                name: clazz.name
            };
            expr.push(macro new $classtype());
        }
        return {
            expr: EArrayDecl(expr),
            pos: Context.currentPos()
        }
    }
}
