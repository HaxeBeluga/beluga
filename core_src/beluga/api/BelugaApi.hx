// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.api ;

import haxe.macro.Expr;
import haxe.web.Dispatch;
import haxe.macro.Context;
import beluga.BelugaException;

//import beluga.core.macro.ModuleLoader;

class BelugaApi {
    private var config = new Map<String, DispatchConfig>();


    public function new() { }

    //Handle url like www.beluga.fr?trigger=login
    public function doDefault(apiName : String, d : Dispatch) {
        if (config.exists(apiName)) {
            var cfg = config.get(apiName);
            d.runtimeDispatch(cfg);
        }
        else
            throw new BelugaException("Can't find " + apiName + " api.");
    }

    macro public function register(ethis : Expr, apiKey : Expr, api : Expr) : Expr {
        return macro ${ethis}.dynamicRegister(${apiKey}, haxe.web.Dispatch.make(${api}));
    }

    public function dynamicRegister(apiKey : String, api : DispatchConfig) {
        config.set(apiKey, api);
    }

}
