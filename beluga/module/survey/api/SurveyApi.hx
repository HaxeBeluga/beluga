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

        beluga.triggerDispatcher.dispatch("beluga_survey_create",
            [{title : args.title, description : args.description, choices : tmp}]);
    }

    public function doVote(args : {id : Int, option : Int}) {
        beluga.triggerDispatcher.dispatch("beluga_survey_vote", [args]);
    }

    public function doPrint(args : {id : Int}) {
        beluga.triggerDispatcher.dispatch("beluga_survey_print", [args]);
    }

    public function doDefault() {
        beluga.triggerDispatcher.dispatch("beluga_survey_default", []);
    }

    public function doRedirect() {
        beluga.triggerDispatcher.dispatch("beluga_survey_redirect", []);
    }

    public function doDelete(args : {id : Int}) {
        beluga.triggerDispatcher.dispatch("beluga_survey_delete", [args]);
    }

}
