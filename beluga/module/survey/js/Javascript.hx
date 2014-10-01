// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey.js;

import js.JQuery;

class Javascript {

    public static function init() {
    	var jq = JQueryHelper.get_JTHIS();

    	addEntry();
    	jq.find("#addEntry").click(function() {
		  	addEntry();
		});
    }

    public static function addEntry(){
    	var jq = JQueryHelper.get_JTHIS();
    	var nb = jq.find("#choice").children().size();

		if (nb == 0) {
			var tmp =  "<input type=\"text\" class=\"form-control\" id=\"choices\" placeholder=\"New choice\" name=\"choices" + "\">";

			tmp = "<div class=\"form-survey\">" + tmp + "</div>";
    		jq.find("#choice").append(tmp);
			nb = 1;
		}
		if (nb < 20) {
			var tmp =  "<input type=\"text\" class=\"form-control\" id=\"choices\" placeholder=\"New choice\" name=\"choices" + nb + "\">";

			tmp = "<div class=\"form-survey\">" + tmp + "</div>";
			jq.find("#choice").append(tmp);
		}
	}
}