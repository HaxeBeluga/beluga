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
        this.module.triggers.defaultPage.dispatch();
    }

    public function doCreate(args : {question : String, answer : String}) {
        this.module.triggers.create.dispatch(args);
    }

    public function doEdit(args : {question_id : Int, question : String, answer : String}) {
        this.module.triggers.edit.dispatch(args);
    }

    public function doDelete(args : {question_id : Int}) {
        this.module.triggers.delete.dispatch(args);
    }
}
