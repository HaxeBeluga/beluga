// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.config;

import beluga.Beluga;
import beluga.module.Module;
import beluga.I18n;
import beluga.tool.DynamicTool;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class Config extends Module {

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) {
        //beluga.api.register("account", new AccountApi(beluga, this));
    }

    public function saveConfig(get, save) {
        var filled = DynamicTool.fill(get(), Web.getParams());
        save(filled);
    }
}
