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

    public function doCreate(args : {question : String, answer : String, parent: Int}) {
        this.module.createFAQ({question : args.question, answer: args.answer, category_id: args.parent});
    }

    public function doEdit(args : {faq_id : Int, question : String, answer : String}) {
        this.module.editFAQ(args);
    }

    public function doDeleteFAQ(args : {id: Int, category_id: Int}) {
        this.module.deleteFAQ({question_id: args.id, category_id: args.category_id});
    }

    public function doDeleteCategory(args : {id: Int, parent_id: Int}) {
        this.module.deleteCategory({category_id: args.id, parent_id: args.parent_id});
    }

    public function doRedirectCreateFAQ(args : {category_id : Int}) {
        this.module.category_id = args.category_id;
        this.module.triggers.redirectCreateFAQ.dispatch();
    }

    public function doRedirectCreateCategory(args : {category_id : Int}) {
        this.module.category_id = args.category_id;
        this.module.triggers.redirectCreateCategory.dispatch();
    }

    public function doPrint(args : {id : Int}) {
        this.module.category_id = args.id;
        this.module.triggers.print.dispatch();
    }

    public function doCreateCategory(args : {name : String, parent : Int}) {
        this.module.createCategory(args);
    }

    public function doCreateFAQ(args : {question : String, answer : String, parent : Int}) {
        this.module.createFAQ({question : args.question, answer: args.answer, category_id: args.parent});
    }

    public function doEditCategory(args : {category_id: Int, name: String}) {
        this.module.editCategory(args);
    }

    public function doEditFAQ(args : {faq_id: Int, question: String, answer: String}) {
        this.module.editFAQ(args);
    }

    public function doRedirectEditCategory(args : {id: Int}) {
        this.module.category_id = args.id;
        this.module.triggers.redirectEditCategory.dispatch();
    }

    public function doRedirectEditFAQ(args : {id: Int}) {
        this.module.faq_id = args.id;
        this.module.triggers.redirectEditFAQ.dispatch();
    }
}
