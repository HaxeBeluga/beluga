package beluga.module.faq;

import haxe.xml.Fast;

import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;

class FaqImpl extends ModuleImpl implements FaqInternal {
    public var triggers = new FaqTrigger();

    // Intern variables for contexts
    private var error_msg : String;
    private var success_msg : String;
    public var faq_id : Int;
    public var category_id : Int;

    // Saved values in case of create FAQ error
    private var question : String;
    private var answer : String;
    private var parent_id : Int;

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
        question = "";
        answer = "";
        faq_id = -1;
        category_id = -1;
    }

    public function redirectEditFAQ() : Bool {
        var faq = getFAQ(faq_id);

        if (faq == null) {
            error_msg = "Unknown category";
            return false;
        }
        return true;
    }

    public function getPrintContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var entries = getAllFromCategory(category_id);
        var cat = getCategory(category_id);

        if (cat != null) {
            parent_id = cat.parent_id;
        }
        if (category_id == -1) {
            return {faqs : entries, categories : entries.categories, path : "/beluga/faq/", parent_id : parent_id,
                error : error_msg, success : success_msg, actual_id : category_id, user : user };
        } else {
            var cat = getCategory(category_id);

            if (cat == null) {
                return {faqs : entries, categories : entries.categories, path : "beluga/faq/", parent_id : parent_id,
                    error : error_msg, success : success_msg, actual_id : category_id, user : user };
            } else {
                return {faqs : entries, categories : entries.categories, path : "/beluga/faq/", user : user, parent_id : parent_id,
                    error : error_msg, success : success_msg, actual_id : category_id, category_name: cat.name };
            }
        }
    }

    public function getCreateContext() : Dynamic {
        return {path : "/beluga/faq/", error : error_msg, success : success_msg, parent: category_id,
            question : question, answer: answer };
    }

    public function getCreateCategoryContext() : Dynamic {
        return {path : "/beluga/faq/", error : error_msg, success : success_msg, parent : category_id};
    }

    public function getEditCategoryContext() : Dynamic {
        var cat = this.getCategory(category_id);

        /*if (cat == null) {
            doEditCategoryFail({error : "Unknown category"});
            return;
        }*/
        return {path : "/beluga/faq/", error : error_msg, success : success_msg, id : category_id,
            name: cat.name};
    }

    public function getEditFAQContext() : Dynamic {
        var faq = getFAQ(faq_id);

        return {path : "/beluga/faq/", error : error_msg, success : success_msg, parent : faq.category_id, id: faq_id,
            question: faq.question, answer: faq.answer};
    }

    private function getCategory(category_id : Int) : CategoryModel {
        for (tmp in CategoryModel.manager.dynamicSearch( { id: category_id} )) {
            return tmp;
        }
        return null;
    }

    public function getCurrentCategory() : CategoryModel {
        for (tmp in CategoryModel.manager.dynamicSearch( { id: category_id} )) {
            return tmp;
        }
        return null;
    }

    private function getFAQ(faq_id : Int) : FaqModel {
        for (tmp in FaqModel.manager.dynamicSearch( { id: faq_id} )) {
            return tmp;
        }
        return null;
    }

    public function getAllCategories() : Array<CategoryModel> {
        var ret = new Array<CategoryModel>();

        for (tmp in CategoryModel.manager.dynamicSearch( {} )) {
            ret.push(tmp);
        }
        return ret;
    }

    private function getAllFromCategory(category_id: Int) : CategoryData {
        var ret = new Array<FaqModel>();
        var ret2 = new Array<CategoryModel>();

        for (tmp in FaqModel.manager.dynamicSearch( { category_id: category_id} )) {
            ret.push(tmp);
        }
        for (tmp in CategoryModel.manager.dynamicSearch( { parent_id: category_id} )) {
            ret2.push(tmp);
        }
        return new CategoryData(ret, ret2);
    }

    public function createFAQ(args : {question : String, answer : String, category_id : Int}) {
        //  Let's save values in case something goes wrong
        question = args.question;
        answer = args.answer;
        category_id = args.category_id;

        if (args.question == "") {
            error_msg = "Incomplete question";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.answer == "") {
            error_msg = "Incomplete answer";
            this.triggers.createFail.dispatch();
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "You need to be logged";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.category_id != -1) {
            var found = false;

            for (tmp in CategoryModel.manager.dynamicSearch({id: args.category_id})) {
                found = true;
                break;
            }
            if (false == found) {
                error_msg = "Unknown category";
                category_id = -1;
                this.triggers.createFail.dispatch();
                return;
            }
        }

        for (tmp in FaqModel.manager.dynamicSearch( { category_id: args.category_id } )) {
            if (tmp.question == args.question) {
                error_msg = "Another entry already treats this question";
                this.triggers.createFail.dispatch();
                return;
            }
        }
        var entry = new FaqModel();

        entry.question = args.question;
        entry.answer = args.answer;
        entry.category_id = args.category_id;
        entry.insert();
        success_msg = "FAQ entry has been created successfully";
        this.triggers.createSuccess.dispatch();
    }

    public function createCategory(args : {name : String, parent: Int}) {
        category_id = args.parent;
        if (args.name == "") {
            error_msg = "Missing name";
            this.triggers.createCategoryFail.dispatch();
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "You need to be logged";
            this.triggers.createCategoryFail.dispatch();
            return;
        }
        var found = false;

        if (args.parent != -1) {
            for (tmp in CategoryModel.manager.dynamicSearch( {id: args.parent} )) {
                if (tmp.name == args.name) {
                    error_msg = "Another category already has this name";
                    this.triggers.createCategoryFail.dispatch();
                    return;
                }
                found = true;
                break;
            }
        } else {
            found = true;
        }
        if (found == false) {
            error_msg = "Unknow category";
            this.triggers.createCategoryFail.dispatch();
            return;
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.parent_id = args.parent;
        entry.insert();
        success_msg = "Category has been created successfully";
        category_id = entry.parent_id;
        this.triggers.createCategorySuccess.dispatch();
    }

    public function deleteFAQ(args : {question_id : Int, category_id : Int}) {
        category_id = args.category_id;
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "You need to be logged";
            this.triggers.deleteFail.dispatch();
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.question_id, category_id: args.category_id} )) {
            tmp.delete();
            success_msg = "FAQ entry has been successfully deleted";
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        error_msg = "Id not found";
        this.triggers.deleteFail.dispatch();
    }

    function clearCategoryData(id: Int, parent_id: Int) : Bool {
        for (tmp in CategoryModel.manager.dynamicSearch( {id : id, parent_id: parent_id} )) {
            var tmp_data = getAllFromCategory(tmp.id);

            for (f in tmp_data.faqs) {
                f.delete();
            }
            for (cat in tmp_data.categories) {
                clearCategoryData(cat.id, id);
            }
            tmp.delete();
            return true;
        }
        return false;
    }

    public function deleteCategory(args : {category_id : Int, parent_id: Int}) {
        category_id = args.parent_id;
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "You need to be logged";
            this.triggers.deleteCategoryFail.dispatch();
            return;
        }
        if (clearCategoryData(args.category_id, args.parent_id) == true) {
            success_msg = "Category has been successfully deleted";
            this.triggers.deleteCategorySuccess.dispatch();
        } else {
            error_msg = "Id not found";
            this.triggers.deleteCategoryFail.dispatch();
        }
    }

    public function editFAQ(args : {faq_id: Int, question : String, answer : String}) {
        faq_id = args.faq_id;
        if (args.question == "" || args.answer == "") {
            error_msg = "Incomplete question and or answer";
            this.triggers.editFail.dispatch();
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "You need to be logged";
            this.triggers.editFail.dispatch();
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.faq_id} )) {
            for (tmp2 in FaqModel.manager.dynamicSearch( { category_id: tmp.category_id} )) {
                if (tmp2.question == args.question) {
                    error_msg = "Another entry treats this question";
                    this.triggers.editFail.dispatch();
                    return;
                }
            }
            tmp.question = args.question;
            tmp.answer = args.answer;
            tmp.update();
            success_msg = "FAQ has been successfully edited";
            category_id = tmp.category_id;
            this.triggers.editSuccess.dispatch();
            return;
        }
        error_msg = "Id not found";
        this.triggers.editFail.dispatch();
    }

    public function editCategory(args : {category_id: Int, name : String}) {
        for (tmp in CategoryModel.manager.dynamicSearch({id: args.category_id})) {
            category_id = tmp.parent_id;
            if (args.name == "") {
                error_msg = "Incomplete name";
                this.triggers.editCategoryFail.dispatch();
                return;
            }
            if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
                error_msg = "You need to be logged";
                this.triggers.editCategoryFail.dispatch();
                return;
            }
            for (tmp2 in CategoryModel.manager.dynamicSearch({parent_id: tmp.parent_id})) {
                if (tmp2.name == args.name) {
                    error_msg = "Another category has this name";
                    this.triggers.editCategoryFail.dispatch();
                    return;
                }
            }
            tmp.name = args.name;
            tmp.update();
            success_msg = "Category has been successfully edited";
            this.triggers.editCategorySuccess.dispatch();
            return;
        }
        category_id = -1;
        error_msg = "Id not found";
        this.triggers.editCategoryFail.dispatch();
    }
}