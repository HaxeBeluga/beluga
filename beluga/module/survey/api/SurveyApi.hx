// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

import beluga.module.survey.Survey;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class SurveyApi {
    public var beluga : Beluga;
    public var module : Survey;

    public function new() {}

    public function doCreate(args : {
        title : String,
        description : String,
        choices : String
    }) {
        var tmp = new Array<String>();
        var x = Web.getParams();
        x.remove("description");
        x.remove("title");

        for (t in x)
            tmp.push(t);
        module.create({title : args.title, description : args.description, choices : tmp});
    }

    public function doVote(args: {id : Int, option : Int}) {
        module.vote({survey_id: args.id, option: args.option});
    }

    public function doPrint(args : {id : Int}) {
        module.print(args.id);
    }

    public function doDefault() {
        module.triggers.defaultSurvey.dispatch();
    }

    public function doRedirect() {
        module.redirect();
    }

    public function doDelete(args : {id : Int}) {
        module.delete(args.id);
    }

}
