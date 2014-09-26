// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.form;

@:autoBuild(beluga.core.form.ConstructorMacro.build())
@:autoBuild(beluga.core.form.ValidateMacro.build())
class Object {
    public var error : Map<String, Array<String>>;

    public function new() : Void {
        this.error = new Map<String, Array<String>>();
    }

    public function validate() : Bool {
        return (!this.error.iterator().hasNext());
    }
}