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
        doPrint({category_id: -1});
    }

    @bTrigger("beluga_print_category")
    public static function _doPrint(args : {category_id : Int}) {
        new FaqTest(Beluga.getInstance()).doPrint(args);
    }

    public function doPrint(args : {category_id : Int}) {
        var data = faq.getAllFromCategory(args.category_id);
        var widget = this.faq.getWidget("faqs");

        widget.context = {faqs : data, categories : data.categories, path : "/faqTest/",
                            error : error_msg, success : success_msg, id : args.category_id };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_faq_redirectCreateCategory")
    public static function _doRedirectCreateCategory(args : {category_id : Int}) {
        new FaqTest(Beluga.getInstance()).doRedirectCreateCategory(args);
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

    @bTrigger("beluga_faq_createCategory")
    public static function _doCreateCategory(args : {name : String, parent : Int}) {
        new FaqTest(Beluga.getInstance()).doCreateCategory(args);
    }

    public function doCreateCategory(args : {name : String, parent : Int}) {
        this.faq.createCategory(args);
    }

    @bTrigger("beluga_faq_createCategory_success")
    public static function _doCreateCategorySuccess(args : {id : Int}) {
        new FaqTest(Beluga.getInstance()).doCreateCategorySuccess(args);
    }

    public function doCreateCategorySuccess(args : {id : Int}) {
        success_msg = "Comment has been created successfully";
        this.doPrint({category_id : args.id});
    }

    @bTrigger("beluga_faq_createCategory_fail")
    public static function _doCreateCategoryFail(args : {error_msg : String, id: Int}) {
        new FaqTest(Beluga.getInstance()).doCreateCategoryFail(args);
    }

    public function doCreateCategoryFail(args : {error_msg : String, id: Int}) {
        success_msg = "Comment has been created successfully";
        var widget = this.faq.getWidget("create_category");

        widget.context = {path : "/faqTest/", error : error_msg, success : success_msg, parent : args.id };

        var faqWidget = widget.render();

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: faqWidget
        });
        Sys.print(html);
    }
}