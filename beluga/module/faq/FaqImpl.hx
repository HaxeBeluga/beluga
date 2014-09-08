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

    public function new() {
        super();
    }

    public function getCategory(category_id : Int) : CategoryModel {
        for (tmp in CategoryModel.manager.dynamicSearch( { id: category_id} )) {
            return tmp;
        }
        return null;
    }

    public function getFAQ(faq_id : Int) : FaqModel {
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

    public function getAllFromCategory(category_id: Int) : CategoryData {
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
        if (args.question == "") {
            this.triggers.createFail.dispatch({ error: "Incomplete question",
                                                question: args.question,
                                                answer: args.answer,
                                                id: args.category_id});
            return;
        }
        if (args.answer == "") {
            this.triggers.createFail.dispatch({ error: "Incomplete answer",
                                                question: args.question,
                                                answer: args.answer,
                                                id: args.category_id});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.createFail.dispatch({ error: "You need to be logged",
                                                question: args.question,
                                                answer: args.answer,
                                                id: args.category_id});
            return;
        }
        if (args.category_id != -1) {
            var found = false;

            for (tmp in CategoryModel.manager.dynamicSearch( { id: args.category_id} )) {
                found = true;
                break;
            }
            if (false == found) {
                this.triggers.createFail.dispatch({ error: "Unknow category",
                                                    question: args.question,
                                                    answer: args.answer,
                                                    id: args.category_id});
                return;
            }
        }

        for (tmp in FaqModel.manager.dynamicSearch( { category_id: args.category_id } )) {
            if (tmp.question == args.question) {
                this.triggers.createFail.dispatch({ error: "Another entry already treats this question",
                                                    question: args.question,
                                                    answer: args.answer,
                                                    id: args.category_id});
                return;
            }
        }
        var entry = new FaqModel();

        entry.question = args.question;
        entry.answer = args.answer;
        entry.category_id = args.category_id;
        entry.insert();
        this.triggers.createSuccess.dispatch({id: args.category_id});
    }

    public static function _createCategory(args : {name : String, parent: Int}) {
        Beluga.getInstance().getModuleInstance(Faq).createCategory(args);
    }

    public function createCategory(args : {name : String, parent: Int}) {
        if (args.name == "") {
            this.triggers.createCategoryFail.dispatch({error: "Missing name", id: args.parent});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.createCategoryFail.dispatch({error: "You need to be logged", id: args.parent});
            return;
        }
        var found = false;

        if (args.parent != -1) {
            for (tmp in CategoryModel.manager.dynamicSearch( { id: args.parent} )) {
                if (tmp.name == args.name) {
                    this.triggers.createCategoryFail.dispatch({error: "Another category already has this name", id: args.parent});
                    return;
                }
                found = true;
                break;
            }
        } else {
            found = true;
        }
        if (found == false) {
            this.triggers.createCategoryFail.dispatch({error: "Unknow category", id: args.parent});
            return;
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.parent_id = args.parent;
        entry.insert();
        this.triggers.createCategorySuccess.dispatch({id: entry.parent_id});
    }

    public function deleteFAQ(args : {question_id : Int, category_id : Int}) {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.deleteFail.dispatch({id: args.category_id, error : "You need to be logged"});
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.question_id, category_id: args.category_id} )) {
            tmp.delete();
            this.triggers.deleteSuccess.dispatch({id: args.category_id});
            return;
        }
        this.triggers.deleteFail.dispatch({id: args.category_id, error : "Id not found"});
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
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.deleteCategoryFail.dispatch({id: args.parent_id, error : "You need to be logged"});
            return;
        }
        if (clearCategoryData(args.category_id, args.parent_id) == true) {
            this.triggers.deleteCategorySuccess.dispatch({id: args.parent_id});
        } else {
            this.triggers.deleteCategoryFail.dispatch({id: args.parent_id, error : "Id not found"});
        }
    }

    public function editFAQ(args : {faq_id: Int, question : String, answer : String}) {
        if (args.question == "" || args.answer == "") {
            this.triggers.editFail.dispatch({error : "Incomplete question and or answer"});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.editFail.dispatch({error : "You need to be logged"});
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.faq_id} )) {
            for (tmp2 in FaqModel.manager.dynamicSearch( { category_id: tmp.category_id} )) {
                if (tmp2.question == args.question) {
                    this.triggers.editFail.dispatch({error : "Another entry treats this question"});
                    return;
                }
            }
            tmp.question = args.question;
            tmp.answer = args.answer;
            tmp.update();
            this.triggers.editSuccess.dispatch({id: tmp.category_id});
            return;
        }
            this.triggers.editFail.dispatch({error : "Id not found"});
    }

    public function editCategory(args : {category_id: Int, name : String}) {
        if (args.name == "") {
            this.triggers.editCategoryFail.dispatch({error : "Incomplete name"});
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.triggers.editCategoryFail.dispatch({error : "You need to be logged"});
            return;
        }
        for (tmp in CategoryModel.manager.dynamicSearch( {id : args.category_id} )) {
            for (tmp2 in CategoryModel.manager.dynamicSearch( { parent_id: tmp.parent_id} )) {
                if (tmp2.name == args.name) {
                    this.triggers.editCategoryFail.dispatch({error : "Another category has this name"});
                    return;
                }
            }
            tmp.name = args.name;
            tmp.update();
            this.triggers.editCategorySuccess.dispatch({id: tmp.parent_id});
            return;
        }
        this.triggers.editCategoryFail.dispatch({error : "Id not found"});
    }
}