// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.tool;

class IDGenerator {
  // TODO : Need to generate a reald random string SHA1 or MD5
  // for example.
    public static function generate(size : UInt) : String {
        var print = new String("qwertyuiopasdfghjklzxcvbnm789456123");
        var key : String = "0";
        for (i in 0...size-1) {
            key += print.charAt(Std.random(print.length));
        }

        return (key);
    }
}