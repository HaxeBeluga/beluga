// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.tool;

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

}