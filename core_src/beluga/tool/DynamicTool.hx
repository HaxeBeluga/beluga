// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.
package beluga.tool;

import haxe.ds.Option;
import Type;

typedef Generator = List<String> -> Dynamic -> Void;

class DynamicTool {
    public static function concatArray(i : Array<Dynamic>) {
        var c = { };
        for (j in i) {
            if (j != null) {
                for (field in Reflect.fields(j)) {
                    var value = Reflect.field(j, field);
                    if (value != null) {
                        Reflect.setField(c, field, value);
                    }
                }
            }
        }
        return c;
    }

    public static function concat(a : Dynamic, b : Dynamic) {
        var c = { };
        if (a != null) {
            for (field in Reflect.fields(a)) {
                var value = Reflect.field(a, field);
                if (value != null) {
                    Reflect.setField(c, field, value);
                }
            }
        }
        if (b != null) {
            for (field in Reflect.fields(b)) {
                var value = Reflect.field(b, field);
                if (value != null) {
                    Reflect.setField(c, field, value);
                }
            }
        }
        return c;
    }
    
    /*
     * 
     * var o = {
     *      attr1: {
     *          attr2: "Value !"
     *      }
     * }
     * 
     * print(getField(o, "attr1.attr2"); //Print "Value !"
     * 
     */
    public static function getField(o : Dynamic, s : String) : Option<Dynamic> {
        return getFieldArray(o, fromDottedName(s));
    }

    /*
     * 
     * var o = {
     *      attr1: {
     *          attr2: "Value !"
     *      }
     * }
     * 
     * print(getField(o, ["attr1", "attr2"]); //Print "Value !"
     * 
     */
    public static function getFieldArray(o : Dynamic, attrList : Array<String>) {
        for (attr in attrList) {
            o = Reflect.field(o, attr);
            if (o == null) return None;
        }
        return Some(o);
    }
    
    /*
     *  Tool to convert array to string like ["level1", "level2", "level3"] to "level1.level2.level3"
     */
    public static var delimiter = ".";

    public static function toDottedName(names : Array<String>) : String {
        var name = "";
        for (n in names) {
            if (n == names[0]) {
                name = n;
            } else {
                name = name + delimiter + n;
            }
        }
        return name;
    }

    public static function fromDottedName(name : String) : Array<String> {
        return name.split(delimiter);
    }

    /*
     * Parser for Web.params();
     */
    private static function getValue(names : Array<String>, params : Map<String, String>) {
        #if php
        delimiter = "_";
        #end
        var name = toDottedName(names);
        #if php
        delimiter = ".";
        #end
        return params.get(name);
    }

    private static function get_obj(value : Dynamic, names : Array<String>, params) {
        var obj = { };
        for (field_name in Reflect.fields(value)) {            
            var field_value = Reflect.field(value, field_name);
            Reflect.setField(obj,field_name, rec_fill(field_value, field_name, names, params));
        }
        return obj;
    }

    private static function rec_fill (value : Dynamic, ?name : String, names : Array<String>, params) : Dynamic {
        if (name != null) names.push(name);
        var param_value = getValue(names, params);
        var casted_value : Dynamic = switch(Type.typeof(value))
        {
            case TInt: cast(param_value, Int);
            case TBool: param_value != null;
            case TClass(String): param_value;
            case TObject: get_obj(value, names, params);
            case _: null;
        }
        names.pop();
        return casted_value;
    }

    public static function fill(value : Dynamic, params : Map<String, String>)
    {
        return rec_fill(value, [], params);
    }
}
