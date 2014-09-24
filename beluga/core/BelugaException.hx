// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core;

import haxe.CallStack;

class BelugaException {
    public var message(default, null) : String;

    public function new(msg : String) {
        this.message = msg;
    }

    public function toString() : String {
        for (it in CallStack.callStack()) {
            switch (it) {
                case FilePos(s, file, line): return this.message;
                default:
            }
        }
        return this.message;
    }
}