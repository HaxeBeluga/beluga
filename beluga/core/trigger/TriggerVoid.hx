// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.trigger;

class TriggerVoid {
    var fctArray = new Array<Void -> Void>();

    public function new()
    {
    }

    public function add(fct : Void -> Void) {
        fctArray.push(fct);
    }

    public function dispatch() {
        for (i in 0...fctArray.length) {
            fctArray[i]();
        }
    }
}