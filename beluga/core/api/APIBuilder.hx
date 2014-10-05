// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.api;

import beluga.core.module.ModuleBuilder;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Compiler;

import beluga.core.macro.ConfigLoader;

class APIBuilder {
    macro public static function build() : Array<Field> {
        Sys.println("Generating Beluga web dispatcher API");

        var fields : Array<Field> = Context.getBuildFields();
        var pos = Context.currentPos();

        if (!ConfigLoader.isReady)
            ConfigLoader.forceBuild();

        for (module in ModuleBuilder.modules) {
            var apiTypePath = {
                    sub: null,
                    params: [],
                    pack: module.type.pack,
                    name: module.type.name + "Api"
                };
            var moduleName = module.type.name;
            var apiAssign = { //_api.module = $i{moduleName}.instance;
                pos: Context.currentPos(),
                expr: EBinop(OpAssign, macro _api.module, {
                    pos: Context.currentPos(),
                    expr: EField( {
                        pos: Context.currentPos(),
                        expr:EConst(CIdent(module.type.pack.join(".")  + "."  + module.type.name))
                    }, "instance")
                })
            };
            fields.push({
                pos: pos,
                name: "do" + moduleName,
                meta: null,
                kind: FFun( {
                    ret: null,
                    params: [],
                    expr: macro {
                        //Make sure temp/session exists if beluga handle session
                        handleSessionPath();
                        Session.start();
                        var _api = $ { module.api };
//                        $apiAssign;
                        _api.module = beluga.module.account.AccountImpl.instance;
                        _api.beluga = belugaInstance;
                        d.dispatch(_api);
                        Session.close();
                    },
                    args: [ {
                        value: null,
                        type: macro : haxe.web.Dispatch,
                        opt: false,
                        name: "d"
                    }]
                }),
                doc: null,
                access: [APublic]
            });
        }

        return fields;
    }
}
