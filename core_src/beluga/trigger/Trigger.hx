// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.trigger;

/**
 * WARNING: Passing a Void argument as ArgType raise compilation Error see: TriggerVoid
 * @author brissa_A
 */
class Trigger<ArgType>
{
    var fctArray = new Array<ArgType -> Void>();

    public function new()
    {
    }

    public function add(fct : ArgType -> Void) {
        fctArray.push(fct);
    }

    public function dispatch(param : ArgType) {
        for (i in 0...fctArray.length) {
            fctArray[i](param);
        }
    }

}
