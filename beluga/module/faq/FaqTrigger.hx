package beluga.module.faq;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class FaqTrigger {
    public var defaultPage = new TriggerVoid();

    public var createFail = new TriggerVoid();
    public var createSuccess = new TriggerVoid();
    public var deleteFail = new TriggerVoid();
    public var deleteSuccess = new TriggerVoid();
    public var editFail = new TriggerVoid();
    public var editSuccess = new TriggerVoid();

    public var createCategoryFail = new TriggerVoid();
    public var createCategorySuccess = new TriggerVoid();
    public var deleteCategoryFail = new TriggerVoid();
    public var deleteCategorySuccess = new TriggerVoid();
    public var editCategoryFail = new TriggerVoid();
    public var editCategorySuccess = new TriggerVoid();

    public var redirectCreateFAQ = new TriggerVoid();
    public var redirectCreateCategory = new TriggerVoid();
    public var print = new TriggerVoid();
    public var redirectEditCategory = new TriggerVoid();
    public var redirectEditFAQ = new TriggerVoid();

    public var edit = new Trigger<{question_id : Int, question : String, answer : String}>();
    public var create = new Trigger<{question : String, answer : String}>();
    public var delete = new Trigger<{question_id: Int}>();

    public function new() {}
}