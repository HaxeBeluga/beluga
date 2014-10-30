// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey.js;

#if js
import js.JQuery;
#end

class Javascript implements beluga.core.macro.Javascript  {

    public function new() {
        //Called when the script is loaded
        #if js
        js.Browser.window.console.log("Survey script started");
        #end
    }

    public function ready() {
        #if js
        if (new JQuery("#choice").children().size() < 2)
            addEntry();
        new JQuery("#addEntry").click(function() {
            trace("toto");
            addEntry();
        });
        #end
    }

    public static function addEntry(){
        #if js
        var nb = new JQuery("#choice").children().size();

        if (nb == 0) {
            var tmp =  "<input type=\"text\" class=\"form-control\" id=\"choices\" placeholder=\"New choice\" name=\"choices" + "\">";

            tmp = "<div class=\"form-survey\">" + tmp + "</div>";
            new JQuery("#choice").append(tmp);
            nb = 1;
        }
        if (nb < 20) {
            var tmp =  "<input type=\"text\" class=\"form-control\" id=\"choices\" placeholder=\"New choice\" name=\"choices" + nb + "\">";

            tmp = "<div class=\"form-survey\">" + tmp + "</div>";
            new JQuery("#choice").append(tmp);
        }
        #end
    }
}