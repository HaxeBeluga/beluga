package beluga.module.faq;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class FaqTrigger {
    public var defaultPage = new TriggerVoid();

    public var createFail = new Trigger<{category_id: Int}>();
    public var createSuccess = new Trigger<{id: Int}>();
    public var deleteFail = new Trigger<{id: Int}>();
    public var deleteSuccess = new Trigger<{id: Int}>();
    public var editFail = new Trigger<{id: Int}>();
    public var editSuccess = new Trigger<{id: Int}>();

    public var createCategoryFail = new Trigger<{category_id: Int}>();
    public var createCategorySuccess = new Trigger<{id: Int}>();
    public var deleteCategoryFail = new Trigger<{id: Int}>();
    public var deleteCategorySuccess = new Trigger<{id: Int}>();
    public var editCategoryFail = new Trigger<{id: Int}>();
    public var editCategorySuccess = new Trigger<{id: Int}>();

    public var edit = new Trigger<{question_id : Int, question : String, answer : String}>();
    public var create = new Trigger<{question : String, answer : String}>();
    public var delete = new Trigger<{question_id: Int}>();

    public function new() {}
}