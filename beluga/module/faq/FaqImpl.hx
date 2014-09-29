// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.faq;

import haxe.xml.Fast;
import haxe.ds.Option;

import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;
import beluga.core.BelugaI18n;

import beluga.module.account.Account;
import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;
import beluga.module.faq.FaqErrorKind;

class FaqImpl extends ModuleImpl implements FaqInternal {
    public var triggers = new FaqTrigger();

    // Intern variables for contexts
    public var error_msg : String;
    public var success_msg : String;
    public var faq_id : Option<Int>;
    public var category_id : Option<Int>;

    // Saved values in case of create FAQ error
    public var question : String;
    public var answer : String;

    public var widgets: FaqWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/module/faq/locale/");

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
        question = "";
        answer = "";
        faq_id = None;
        category_id = None;
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new FaqWidget();
    }

    // change this function name or remove/replace it
    public function redirectEditFAQ() : Bool {
        var faq = getFAQ(switch (faq_id) {
                case Some(id) : id;
                case None : -1;
            });

        if (faq == null) {
            error_msg = "unknown_category";
            return false;
        }
        return true;
    }

    public function getCategory(category_id : Int) : CategoryModel {
        for (category in CategoryModel.manager.dynamicSearch( { id: category_id} )) {
            return category;
        }
        return null;
    }

    public function getCurrentCategory() : CategoryModel {
        var unwrap_id = switch(category_id) {
            case Some(id) : id;
            case None : -1;
        };
        for (current_category in CategoryModel.manager.dynamicSearch( { id: unwrap_id} )) {
            return current_category;
        }
        return null;
    }

    public function getFAQ(faq_id : Int) : FaqModel {
        for (faq in FaqModel.manager.dynamicSearch( { id: faq_id} )) {
            return faq;
        }
        return null;
    }

    public function getAllCategories() : Array<CategoryModel> {
        var ret = new Array<CategoryModel>();

        for (category in CategoryModel.manager.dynamicSearch( {} )) {
            ret.push(category);
        }
        return ret;
    }

    public function getAllFromCategory(category_id: Int) : CategoryData {
        var faq_array = new Array<FaqModel>();
        var category_array = new Array<CategoryModel>();

        for (faq in FaqModel.manager.dynamicSearch( { category_id: category_id} )) {
            faq_array.push(faq);
        }
        for (category in CategoryModel.manager.dynamicSearch( { parent_id: category_id} )) {
            category_array.push(category);
        }
        return new CategoryData(faq_array, category_array);
    }

    public function createFAQ(args : {question : String, answer : String, category_id : Int}) {
        //  Let's save values in case something goes wrong
        question = args.question;
        answer = args.answer;
        category_id = Some(args.category_id);

        if (args.question == "") {
            error_msg = "missing_question";
            this.triggers.createFail.dispatch({error: MissingQuestion});
            return;
        }
        if (args.answer == "") {
            error_msg = "missing_answer";
            this.triggers.createFail.dispatch({error: MissingAnswer});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "missing_login";
            this.triggers.createFail.dispatch({error: MissingLogin});
            return;
        }
        if (args.category_id != -1) {
            var found = false;

            for (category in CategoryModel.manager.dynamicSearch({id: args.category_id})) {
                found = true;
                break;
            }
            if (false == found) {
                error_msg = "unknown_category";
                category_id = None;
                this.triggers.createFail.dispatch({error: UnknownCategory});
                return;
            }
        }

        for (faq in FaqModel.manager.dynamicSearch( { category_id: args.category_id } )) {
            if (faq.question == args.question) {
                error_msg = "entry_already_exists";
                this.triggers.createFail.dispatch({error: EntryAlreadyExists});
                return;
            }
        }
        var entry = new FaqModel();

        entry.question = args.question;
        entry.answer = args.answer;
        entry.category_id = args.category_id;
        entry.insert();
        success_msg = "entry_create_success";
        this.triggers.createSuccess.dispatch();
    }

    public function createCategory(args : {name : String, parent: Int}) {
        category_id = Some(args.parent);
        if (args.name == "") {
            error_msg = "missing_name";
            this.triggers.createCategoryFail.dispatch({error: MissingName});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "missing_login";
            this.triggers.createCategoryFail.dispatch({error: MissingLogin});
            return;
        }

        // check if another category already has the same name
        for (category in CategoryModel.manager.dynamicSearch( {parent_id: args.parent} )) {
            if (category.name == args.name) {
                error_msg = "category_already_exists";
                this.triggers.createCategoryFail.dispatch({error: CategoryAlreadyExists});
                return;
            }
        }

        // check if the parent category exist
        if (args.parent != -1) {
            var found = false;

            for (category in CategoryModel.manager.dynamicSearch( {id: args.parent} )) {
                found = true;
                break;
            }
            if (found == false) {
                error_msg = "unknown_category";
                this.triggers.createCategoryFail.dispatch({error: UnknownCategory});
                return;
            }
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.parent_id = args.parent;
        entry.insert();
        success_msg = "category_create_success";
        category_id = Some(entry.parent_id);
        this.triggers.createCategorySuccess.dispatch();
    }

    public function deleteFAQ(args : {question_id : Int, category_id : Int}) {
        category_id = Some(args.category_id);
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "missing_login";
            this.triggers.deleteFail.dispatch({error: MissingLogin});
            return;
        }
        for (faq in FaqModel.manager.dynamicSearch( {id : args.question_id, category_id: args.category_id} )) {
            faq.delete();
            success_msg = "faq_delete_success";
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        error_msg = "id_not_found";
        this.triggers.deleteFail.dispatch({error: IdNotFound});
    }

    function clearCategoryData(id: Int, parent_id: Int) : Bool {
        for (category in CategoryModel.manager.dynamicSearch( {id : id, parent_id: parent_id} )) {
            var category_to_delete = getAllFromCategory(category.id);

            for (faq in category_to_delete.faqs) {
                faq.delete();
            }
            for (sub_category in category_to_delete.categories) {
                clearCategoryData(sub_category.id, id);
            }
            category.delete();
            return true;
        }
        return false;
    }

    public function deleteCategory(args : {category_id : Int, parent_id: Int}) {
        category_id = Some(args.parent_id);
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "missing_login";
            this.triggers.deleteCategoryFail.dispatch({error: MissingLogin});
            return;
        }
        if (clearCategoryData(args.category_id, args.parent_id) == true) {
            success_msg = "category_delete_success";
            this.triggers.deleteCategorySuccess.dispatch();
        } else {
            error_msg = "id_not_found";
            this.triggers.deleteCategoryFail.dispatch({error: IdNotFound});
        }
    }

    public function editFAQ(args : {faq_id: Int, question : String, answer : String}) {
        faq_id = Some(args.faq_id);
        if (args.question == "") {
            error_msg = "missing_question";
            this.triggers.editFail.dispatch({error: MissingQuestion});
            return;
        }
        if (args.answer == "") {
            error_msg = "missing_answer";
            this.triggers.editFail.dispatch({error: MissingAnswer});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "missing_login";
            this.triggers.editFail.dispatch({error: MissingLogin});
            return;
        }
        for (faq in FaqModel.manager.dynamicSearch( {id : args.faq_id} )) {
            for (faq_to_compare in FaqModel.manager.dynamicSearch( { category_id: faq.category_id} )) {
                if (faq_to_compare.question == args.question) {
                    error_msg = "entry_already_exists";
                    this.triggers.editFail.dispatch({error: EntryAlreadyExists});
                    return;
                }
            }
            faq.question = args.question;
            faq.answer = args.answer;
            faq.update();
            success_msg = "faq_edit_success";
            category_id = Some(faq.category_id);
            this.triggers.editSuccess.dispatch();
            return;
        }
        error_msg = "id_not_found";
        this.triggers.editFail.dispatch({error: IdNotFound});
    }

    public function editCategory(args : {category_id: Int, name : String}) {
        for (category_to_edit in CategoryModel.manager.dynamicSearch({id: args.category_id})) {
            category_id = Some(category_to_edit.parent_id);
            if (args.name == "") {
                error_msg = "missing_name";
                this.triggers.editCategoryFail.dispatch({error: MissingName});
                return;
            }
            if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
                error_msg = "missing_login";
                this.triggers.editCategoryFail.dispatch({error: MissingLogin});
                return;
            }
            for (same_level_category in CategoryModel.manager.dynamicSearch({parent_id: category_to_edit.parent_id})) {
                if (same_level_category.name == args.name) {
                    error_msg = "category_already_exists";
                    this.triggers.editCategoryFail.dispatch({error: CategoryAlreadyExists});
                    return;
                }
            }
            category_to_edit.name = args.name;
            category_to_edit.update();
            success_msg = "category_edit_success";
            this.triggers.editCategorySuccess.dispatch();
            return;
        }
        category_id = None;
        error_msg = "id_not_found";
        this.triggers.editCategoryFail.dispatch({error: IdNotFound});
    }
}