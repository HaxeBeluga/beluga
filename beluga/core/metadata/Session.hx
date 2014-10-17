package beluga.core.metadata ;

import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import beluga.core.FlashData;
import haxe.Session;
#if macro
import tink.macro.Member;
#end

class Session
{
    macro public static function build() :Array<Field> {
        var fieldList = Context.getBuildFields();
        var newFieldList = new Array<Field>();
        for (field in fieldList) {
            var builded : Bool;
            var build = function (fct : Field -> Array<Field> -> Void) {
                if (builded) {
                    Context.fatalError("A field can only be in a unique scope(Session or Flashdata not both)", Context.currentPos());
                } else {
                    builded = true;
                    fct(field, newFieldList);
                }
            }
            for (meta in field.meta) {
                switch (meta.name) {
                    case ":Session": build(session);
                    case ":FlashData": build(flashdata);
                }
            }
        }
        return fieldList.concat(newFieldList);
    } 
    
    #if macro
    private static function session(field : Field, fieldList : Array<Field>) : Void {
        var test : Member = cast field;
        test.addMeta(":isVar");
        switch(field.kind) {
            case FProp(get, set, type, expr) :
            fieldList.push(Member.setter(field.name, macro {
                    Session.set("beluga_session_"+$v{field.name}, param);
            }, type));
            fieldList.push(Member.getter(field.name, macro {
                    return Session.get("beluga_session_" + $v{field.name});
            }, type));
            default: Context.fatalError("Can't use ScopeData on non-property", Context.currentPos());
        }
        
    }

    private static function flashdata(field : Field, fieldList : Array<Field>) : Void{
        var test : Member = cast field;
        test.addMeta(":isVar");
        switch(field.kind) {
            case FProp(get, set, type, expr) :
            fieldList.push(Member.setter(field.name, macro {
                    FlashData.set("beluga_flashdata_"+$v{field.name}, param);
            }, type));
            fieldList.push(Member.getter(field.name, macro {
                    return FlashData.get("beluga_flashdata_"+$v{field.name});
            }, type));
            default: Context.fatalError("Can't use ScopeData on non-property", Context.currentPos());
        }
    }
    #end
}
