// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.api;

import haxe.web.Dispatch;
import haxe.Session;

//import beluga.core.macro.ModuleLoader;

class BelugaApi {
    public var belugaInstance : Beluga;
    public var modules = new Map<String, Dynamic>();

    public function new() {}

    //Handle url like www.beluga.fr?trigger=login
    public function doDefault(d : Dispatch) {
        var module = d.parts.shift();
        var api = modules.get(module);
        d.runtimeDispatch(api);
    }

}
