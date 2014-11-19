// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.js;

import beluga.Config;
import beluga.module.account.AccountConfig;

class Javascript implements beluga.resource.Javascript {

    
    public function new() {
        #if js
        //Called when the script is loaded
        js.Browser.window.console.log("Account script started");
        AccountConfig.get(onConf);
        #end
    }
    
    #if js
    public function onConf(conf : Dynamic) {
    }
    #end
    
    public function ready()
    {
        #if js
        //Called when the DOM is ready
        js.Browser.window.console.log("DOM Ready");	
        #end
    }

}
