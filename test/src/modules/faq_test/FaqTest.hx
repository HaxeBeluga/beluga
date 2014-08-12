package modules.faq_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.faq.Faq;
import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;
import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;
import sys.db.Types;

#if php
import php.Web;
#end

/**
 * @author Guillaume Gomez
 */

class FaqTest implements MetadataReader
{
    public var beluga(default, null) : Beluga;
    public var faq(default, null) : Faq;
    private var error_msg : String;
    private var success_msg : String;
    private var id : Int;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.faq = beluga.getModuleInstance(Faq);
        this.error_msg = "";
        this.success_msg = "";
        this.id = -1;
    }

    @bTrigger("beluga_faq_default")
    public static function _doDefault() {
        new FaqTest(Beluga.getInstance()).doDefault();
    }

    public function doDefault() {
        doPrint({id: -1});
    }

    public function doPrint(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
        var data = faq.getAllFromCategory(args.id);
        var cat = faq.getCategory(args.id);
        var widget = this.faq.getWidget("faqs");
        var parent_id = -1;

        if (cat != null) {
            parent_id = cat.parent_id;
        }
        if (args.id == -1) {
            widget.context = {faqs : data, categories : data.categories, path : "/faqTest/", parent_id : parent_id,
                                error : error_msg, success : success_msg, actual_id : args.id, user : user };
        } else {
            var cat = faq.getCategory(args.id);

            if (cat == null) {
                widget.context = {faqs : data, categories : data.categories, path : "/faqTest/", parent_id : parent_id,
                                error : error_msg, success : success_msg, actual_id : args.id, user : user };
            } else {
                widget.context = {faqs : data, categories : data.categories, path : "/faqTest/", user : user, parent_id : parent_id,
                                error : error_msg, success : success_msg, actual_id : args.id, category_name: cat.name };
            }
        }

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doRedirectCreateCategory(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_category");

        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : args.category_id };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doRedirectCreateFAQ(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_faq");

        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : args.category_id };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doCreateCategory(args : {name : String, parent : Int}) {
        this.faq.createCategory(args);
    }

    @bTrigger("beluga_faq_createCategory_success")
    public static function _doCreateCategorySuccess(args : {id : Int}) {
        new FaqTest(Beluga.getInstance()).doCreateCategorySuccess(args);
    }

    public function doCreateCategorySuccess(args : {id : Int}) {
        success_msg = "Category has been created successfully";
        this.doPrint({id : args.id});
    }

    @bTrigger("beluga_faq_createCategory_fail")
    public static function _doCreateCategoryFail(args : {error_msg : String, id: Int}) {
        new FaqTest(Beluga.getInstance()).doCreateCategoryFail(args);
    }

    public function doCreateCategoryFail(args : {error_msg : String, id: Int}) {
        error_msg = args.error_msg;
        doRedirectCreateCategory({category_id: args.id});
    }


    public function doCreateFAQ(args : {question : String, answer : String, parent : Int}) {
        this.faq.createFAQ({question : args.question, answer: args.answer, category_id: args.parent});
    }

    @bTrigger("beluga_faq_createFAQ_success")
    public static function _doCreateFAQSuccess(args : {id : Int}) {
        new FaqTest(Beluga.getInstance()).doCreateFAQSuccess(args);
    }

    public function doCreateFAQSuccess(args : {id : Int}) {
        success_msg = "FAQ entry has been created successfully";
        this.doPrint({id : args.id});
    }

    @bTrigger("beluga_faq_createFAQ_fail")
    public static function _doCreateFAQFail(args : {error_msg : String, question: String, answer: String, id: Int}) {
        new FaqTest(Beluga.getInstance()).doCreateFAQFail(args);
    }

    public function doCreateFAQFail(args : {error_msg : String, question: String, answer: String, id: Int}) {
        error_msg = args.error_msg;
        var widget = this.faq.getWidget("create_faq");

        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : args.id,
            question : args.question, answer: args.answer };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doDeleteFAQ(args : {id: Int, category_id: Int}) {
        this.faq.deleteFAQ({question_id: args.id, category_id: args.category_id});
    }

    @bTrigger("beluga_faq_deleteFAQ_fail")
    public static function _doDeleteFAQFail(args : {id : Int, error: String}) {
        new FaqTest(Beluga.getInstance()).doDeleteFAQFail(args);
    }

    public function doDeleteFAQFail(args : {id : Int, error: String}) {
        error_msg = args.error;
        doPrint({id: args.id});
    }

    @bTrigger("beluga_faq_deleteFAQ_success")
    public static function _doDeleteFAQSuccess(args : {id : Int, error: String}) {
        new FaqTest(Beluga.getInstance()).doDeleteFAQSuccess(args);
    }

    public function doDeleteFAQSuccess(args : {id : Int, error: String}) {
        success_msg = "FAQ entry has been successfully deleted";
        doPrint({id: args.id});
    }

    public function doDeleteCategory(args : {id: Int, parent_id: Int}) {
        this.faq.deleteCategory({category_id: args.id, parent_id: args.parent_id});
    }

    @bTrigger("beluga_faq_deleteCategory_fail")
    public static function _doDeleteCategoryFail(args : {id : Int, error: String}) {
        new FaqTest(Beluga.getInstance()).doDeleteCategoryFail(args);
    }

    public function doDeleteCategoryFail(args : {id : Int, error: String}) {
        error_msg = args.error;
        doPrint({id: args.id});
    }

    @bTrigger("beluga_faq_deleteCategory_success")
    public static function _doDeleteCategorySuccess(args : {id : Int, error: String}) {
        new FaqTest(Beluga.getInstance()).doDeleteCategorySuccess(args);
    }

    public function doDeleteCategorySuccess(args : {id : Int, error: String}) {
        success_msg = "Category has been successfully deleted";
        doPrint({id: args.id});
    }

    public function doRedirectEditCategory(args : {id: Int}) {
        var widget = this.faq.getWidget("edit_category");
        var cat = faq.getCategory(args.id);

        if (cat == null) {
            doEditCategoryFail({error : "Unknown category"});
            return;
        }
        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : cat.parent_id, id: args.id,
            name: cat.name };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doEditCategory(args : {category_id: Int, name: String}) {
        this.faq.editCategory(args);
    }

    @bTrigger("beluga_faq_editCategory_fail")
    public static function _doEditCategoryFail(args : {error: String}) {
        new FaqTest(Beluga.getInstance()).doEditCategoryFail(args);
    }

    public function doEditCategoryFail(args : {error: String}) {
        error_msg = args.error;
        doPrint({id: -1});
    }

    @bTrigger("beluga_faq_editCategory_success")
    public static function _doEditCategorySuccess(args : {id : Int}) {
        new FaqTest(Beluga.getInstance()).doEditCategorySuccess(args);
    }

    public function doEditCategorySuccess(args : {id : Int}) {
        success_msg = "Category has been successfully edited";
        doPrint({id: args.id});
    }

    public function doRedirectEditFAQ(args : {id: Int}) {
        var widget = this.faq.getWidget("edit_faq");
        var faq = faq.getFAQ(args.id);

        if (faq == null) {
            doEditFAQFail({error : "Unknown category"});
            return;
        }
        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : faq.category_id, id: args.id,
            question: faq.question, answer: faq.answer };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    public function doEditFAQ(args : {faq_id: Int, question: String, answer: String}) {
        this.faq.editFAQ(args);
    }

    @bTrigger("beluga_faq_editFAQ_fail")
    public static function _doEditFAQFail(args : {error: String}) {
        new FaqTest(Beluga.getInstance()).doEditFAQFail(args);
    }

    public function doEditFAQFail(args : {error: String}) {
        error_msg = args.error;
        doPrint({id: -1});
    }

    @bTrigger("beluga_faq_editFAQ_success")
    public static function _doEditFAQSuccess(args : {id : Int}) {
        new FaqTest(Beluga.getInstance()).doEditFAQSuccess(args);
    }

    public function doEditFAQSuccess(args : {id : Int}) {
        success_msg = "Category has been successfully edited";
        doPrint({id: args.id});
    }
}