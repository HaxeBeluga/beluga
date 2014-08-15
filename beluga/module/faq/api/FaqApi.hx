package beluga.module.faq.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

import beluga.module.faq.Faq;

class FaqApi {
    public var beluga : Beluga;
    public var module : Faq;

    public function new() {
    }

    public function doDefault() {
        beluga.triggerDispatcher.dispatch("beluga_faq_default", []);
    }

    public function doCreate(args : {question : String, answer : String}) {
        beluga.triggerDispatcher.dispatch("beluga_faq_create", [args]);
    }

    public function doEdit(args : {question_id : Int, question : String, answer : String}) {
        beluga.triggerDispatcher.dispatch("beluga_faq_edit", [args]);
    }

    public function doDelete(args : {question_id : Int}) {
        beluga.triggerDispatcher.dispatch("beluga_faq_delete", [args]);
    }
}
