// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.form;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

import haxe.macro.ExprTools;

//[{  name => args,
//    type => TAnonymous([{
//                      kind => FVar(TPath({ name => String, pack => [], params => [] }), null),
//                      meta => [],
//                      name => name,
//                      doc => null,
//                      pos => #pos(src/MyForm.hx:7: characters 33-48),
//                      access => [] }]),
//    opt => false,
//    value => null }]

class ConstructorMacro {

    private static function generateAssignement(field : Field) : Expr {
        var var_name = field.name;
        var assignement = macro
        {
            this.$var_name = args.$var_name;
        }

        return assignement;
    }

    private static function addSuperCall() : Expr {
        return macro { super(); };
    }

    private static function generateConstructorBody(fields : Array<Field>) : Expr {
        var body_proto = new Array<Expr>();

        body_proto.push(addSuperCall());

        // Create condition statement which analyze form data
        for (field in fields) {
            if (field.kind.getName() == "FVar") {
                body_proto.push(generateAssignement(field));
            }
        }

        return { expr : EBlock(body_proto), pos : Context.currentPos() };
    }

    private static function generateConstructorParam(fields : Array<Field>) : Array<FunctionArg> {
        var form_vars = new Array<Field>();

        for (field in fields) {
            if (field.kind.getName() == "FVar") {
                form_vars.push(field);
            }
        }

        return [{ name : "args", type : TAnonymous(form_vars), opt : false, value : null }];
    }

    private static function createConstructorFunction(fields : Array<Field>) : Field {
        // Define return type of constructor function
        var ret_proto = TPath({
          name   : "Void",
          pack   : [],
          params : []
        });

        // Build constructor function
        var funct_proto = FFun({
          ret    : ret_proto,
          params : [],
          expr   : generateConstructorBody(fields),
          args   : generateConstructorParam(fields)
        });

        // Parametrization of constructor function
        var constructor_func = {
          name   : "new",
          kind   : funct_proto,
          access : [APublic],
          meta   : [],
          doc    : null,
          pos    : Context.currentPos()
        }

        return constructor_func;
    }

    macro public static function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var constructor_function = createConstructorFunction(fields);
        fields.push(constructor_function);
        return fields;
    }

}

