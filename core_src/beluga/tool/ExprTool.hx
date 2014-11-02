// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.tool ;

using Lambda;

import haxe.macro.Expr;
#if macro
import haxe.macro.Context;
#end

class ExprTool {
    public static function concat(beg_expr : Expr, end_expr : Expr) : Expr {
        return ((beg_expr != null) ? macro {${beg_expr} ${end_expr}} : macro $end_expr);
    }

    /*
    ** To be used only on new() Expr
    */
    #if macro
    public static function insertInConstructor(exprToInsert : Expr, constructor : Field) : Field {
        switch (constructor.kind) {
            case FFun({args: a, expr: e, params: p, ret: r}):
                var newBlock : Expr;

                switch (e.expr) {
                    case EBlock( blockContent ):
                        var newBlockContent = blockContent.copy();

                        switch (blockContent) {
                            case blockContent[0] => { expr:ECall( { expr:EConst(CIdent("super")) }, []) } :
                                newBlockContent.insert(1, exprToInsert);
                            default :
                                newBlockContent.insert(0, exprToInsert);
                        }
                        newBlockContent.iter(function(expr) expr.pos = Context.currentPos());
                        newBlock = macro $b{newBlockContent};
                    default:
                }
                constructor.kind = FFun( {
                    args  : a,
                    params: p,
                    ret   : r,
                    expr  : newBlock
                });
            default:
                //nothing to do
        }
        return constructor;
    }
    #end
    //if expr is String EConst return the value else return null
    public static function getCString(expr : Expr) : Null<String>{
        return switch(expr.expr) {
            case EConst(c):
                switch (c) {
                    case CString(str): str;
                    default : null;
                }
            default: null;
        }
    }
}