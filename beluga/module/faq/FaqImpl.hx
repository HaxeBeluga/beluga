package beluga.module.faq;

import haxe.xml.Fast;

import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;

class FaqImpl extends ModuleImpl implements FaqInternal {

    public function new() {
        super();
    }

    override public function loadConfig(data : Fast) {}

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

    public static function _createFAQ(args : {question : String, answer : String, category_id : Int}) {
        Beluga.getInstance().getModuleInstance(Faq).createFAQ(args);
    }

    public function createFAQ(args : {question : String, answer : String, category_id : Int}) {
        if (args.question == "") {
            beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_fail",
            [{error_msg : "Incomplete question", question: args.question, answer: args.answer, id: args.category_id}]);
            return;
        }
        if (args.answer == "") {
            beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_fail",
            [{error_msg : "Incomplete answer", question: args.question, answer: args.answer, id: args.category_id}]);
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_fail",
            [{error_msg : "You need to be logged", question: args.question, answer: args.answer, id: args.category_id}]);
            return;
        }
        if (args.category_id != -1) {
            var found = false;

            for (tmp in CategoryModel.manager.dynamicSearch( { id: args.category_id} )) {
                found = true;
                break;
            }
            if (false == found) {
                beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_fail",
                [{error_msg : "Unknow category", question: args.question, answer: args.answer, id: args.category_id}]);
                return;
            }
        }

        for (tmp in FaqModel.manager.dynamicSearch( { category_id: args.category_id } )) {
            if (tmp.question == args.question) {
                beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_fail",
                [{error_msg : "Another entry already treats this question", question: args.question, answer: args.answer, id: args.category_id}]);
                return;
            }
        }
        var entry = new FaqModel();

        entry.question = args.question;
        entry.answer = args.answer;
        entry.category_id = args.category_id;
        entry.insert();
        beluga.triggerDispatcher.dispatch("beluga_faq_createFAQ_success", [{id: args.category_id}]);
    }

    public static function _createCategory(args : {name : String, parent: Int}) {
        Beluga.getInstance().getModuleInstance(Faq).createCategory(args);
    }

    public function createCategory(args : {name : String, parent: Int}) {
        if (args.name == "") {
            beluga.triggerDispatcher.dispatch("beluga_faq_createCategory_fail", [{error_msg : "Missing name", id: args.parent}]);
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_createCategory_fail", [{error_msg : "You need to be logged", id: args.parent}]);
            return;
        }
        var found = false;

        if (args.parent != -1) {
            for (tmp in CategoryModel.manager.dynamicSearch( { id: args.parent} )) {
                if (tmp.name == args.name) {
                    beluga.triggerDispatcher.dispatch("beluga_faq_createCategory_fail", [{error_msg : "Another category already has this name", id: args.parent}]);
                    return;
                }
                found = true;
                break;
            }
        } else {
            found = true;
        }
        if (found == false) {
            beluga.triggerDispatcher.dispatch("beluga_faq_createCategory_fail", [{error_msg : "Invalid parent id", id: args.parent}]);
            return;
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.parent_id = args.parent;
        entry.insert();
        beluga.triggerDispatcher.dispatch("beluga_faq_createCategory_success", [{id: entry.parent_id}]);
    }

    public static function _deleteFAQ(args : {question_id : Int, category_id : Int}) {
        Beluga.getInstance().getModuleInstance(Faq).deleteFAQ(args);
    }

    public function deleteFAQ(args : {question_id : Int, category_id : Int}) {
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_deleteFAQ_fail", [{id: args.category_id, error : "You need to be logged"}]);
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.question_id, category_id: args.category_id} )) {
            tmp.delete();
            beluga.triggerDispatcher.dispatch("beluga_faq_deleteFAQ_success", [{id: args.category_id}]);
            return;
        }
        beluga.triggerDispatcher.dispatch("beluga_faq_deleteFAQ_fail", [{id: args.category_id, error : "Id not found"}]);
    }

    public static function _deleteCategory(args : {category_id : Int, parent_id: Int}) {
        Beluga.getInstance().getModuleInstance(Faq).deleteCategory(args);
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
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_deleteCategory_fail", [{id: args.parent_id, error : "You need to be logged"}]);
            return;
        }
        if (clearCategoryData(args.category_id, args.parent_id) == true) {
            beluga.triggerDispatcher.dispatch("beluga_faq_deleteCategory_success", [{id: args.parent_id}]);
        } else {
            beluga.triggerDispatcher.dispatch("beluga_faq_deleteCategory_fail", [{id: args.parent_id, error : "Id not found"}]);
        }
    }

    public static function _editFAQ(args : {faq_id: Int, question : String, answer : String}) {
        Beluga.getInstance().getModuleInstance(Faq).editFAQ(args);
    }

    public function editFAQ(args : {faq_id: Int, question : String, answer : String}) {
        if (args.question == "" || args.answer == "") {
            beluga.triggerDispatcher.dispatch("beluga_faq_editFAQ_fail", [{error : "Incomplete question and or answer"}]);
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_editFAQ_fail", [{error : "You need to be logged"}]);
            return;
        }
        for (tmp in FaqModel.manager.dynamicSearch( {id : args.faq_id} )) {
            for (tmp2 in FaqModel.manager.dynamicSearch( { category_id: tmp.category_id} )) {
                if (tmp2.question == args.question) {
                    beluga.triggerDispatcher.dispatch("beluga_faq_editFAQ_fail", [{error : "Another entry treats this question"}]);
                    return;
                }
            }
            tmp.question = args.question;
            tmp.answer = args.answer;
            tmp.update();
            beluga.triggerDispatcher.dispatch("beluga_faq_editFAQ_success", [{id: tmp.category_id}]);
            return;
        }
        beluga.triggerDispatcher.dispatch("beluga_faq_editFAQ_fail", [{error : "Id not found"}]);
    }

    public static function _editCategory(args : {category_id: Int, name : String}) {
        Beluga.getInstance().getModuleInstance(Faq).editCategory(args);
    }

    public function editCategory(args : {category_id: Int, name : String}) {
        if (args.name == "") {
            beluga.triggerDispatcher.dispatch("beluga_faq_editCategory_fail", [{error : "Incomplete name"}]);
            return;
        }
        if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
            beluga.triggerDispatcher.dispatch("beluga_faq_editCategory_fail", [{error : "You need to be logged"}]);
            return;
        }
        for (tmp in CategoryModel.manager.dynamicSearch( {id : args.category_id} )) {
            for (tmp2 in CategoryModel.manager.dynamicSearch( { parent_id: tmp.parent_id} )) {
                if (tmp2.name == args.name) {
                    beluga.triggerDispatcher.dispatch("beluga_faq_editCategory_fail", [{error : "Another category has this name"}]);
                    return;
                }
            }
            tmp.name = args.name;
            tmp.update();
            beluga.triggerDispatcher.dispatch("beluga_faq_editCategory_success", [{id: tmp.parent_id}]);
            return;
        }
        beluga.triggerDispatcher.dispatch("beluga_faq_editCategory_fail", [{error : "Id not found"}]);
    }
}