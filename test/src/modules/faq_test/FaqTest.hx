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

class FaqTest
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
        var data = faq.getAllFromCategory(args.id);
        var widget = this.faq.getWidget("faqs");

        if (args.id == -1) {
            widget.context = {faqs : data, categories : data.categories, path : "/faqTest/",
                                error : error_msg, success : success_msg, id : args.id };
        } else {
            var cat = faq.getCategory(args.id);

            if (cat == null) {
                widget.context = {faqs : data, categories : data.categories, path : "/faqTest/",
                                error : error_msg, success : success_msg, id : args.id };
            } else {
                widget.context = {faqs : data, categories : data.categories, path : "/faqTest/",
                                error : error_msg, success : success_msg, id : args.id, category_name: cat.name };
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
}