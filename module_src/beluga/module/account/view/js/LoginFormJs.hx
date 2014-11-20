// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.view.js;

#if js
import js.Browser;
#end

class LoginFormJs implements beluga.resource.Javascript {

    #if js
    private var cnx : haxe.remoting.HttpAsyncConnection ;
    #end

    public function new() {
        #if js
        //Called when the script is loaded
        js.Browser.window.console.log("LoginFormJs script started");
        cnx = haxe.remoting.HttpAsyncConnection.urlConnect("http://" + Browser.location.host + "/beluga/");
        cnx.setErrorHandler( function(err) { trace("Error : " + Std.string(err)); } );
        cnx.Account.login.call(["toto", "tata"], onLogin);
        #end
    }
    
    public function onLogin(v) {
        trace(v);
    }
    
    public function ready()
    {
        #if js
        //Called when the DOM is ready
        js.Browser.window.console.log("DOM Ready");	
        #end
    }

}
