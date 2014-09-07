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

class FaqTest {
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

        this.faq.triggers.defaultPage.add(this.doDefault);
        this.faq.triggers.createCategorySuccess.add(this.doCreateCategorySuccess);
        this.faq.triggers.createCategoryFail.add(this.doCreateCategoryFail);
        this.faq.triggers.deleteCategorySuccess.add(this.doCreateCategorySuccess);
        this.faq.triggers.deleteCategoryFail.add(this.doCreateCategoryFail);
        this.faq.triggers.editCategorySuccess.add(this.doEditCategorySuccess);
        this.faq.triggers.editCategoryFail.add(this.doEditCategoryFail);

        this.faq.triggers.createSuccess.add(this.doCreateFAQSuccess);
        this.faq.triggers.createFail.add(this.doCreateFAQFail);
        this.faq.triggers.deleteSuccess.add(this.doDeleteFAQSuccess);
        this.faq.triggers.deleteFail.add(this.doDeleteFAQFail);
        this.faq.triggers.editSuccess.add(this.doEditFAQSuccess);
        this.faq.triggers.editFail.add(this.doEditFAQFail);
    }

    public function doDefault() {
        doPrint({id: -1});
    }

    public function doPrint(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
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

    public function doCreateCategorySuccess(args : {id : Int}) {
        success_msg = "Category has been created successfully";
        this.doPrint({id : args.id});
    }

    public function doCreateCategoryFail(args : {error : String, id: Int}) {
        error_msg = args.error;
        doRedirectCreateCategory({category_id: args.id});
    }


    public function doCreateFAQ(args : {question : String, answer : String, parent : Int}) {
        this.faq.createFAQ({question : args.question, answer: args.answer, category_id: args.parent});
    }

    public function doCreateFAQSuccess(args : {id : Int}) {
        success_msg = "FAQ entry has been created successfully";
        this.doPrint({id : args.id});
    }

    public function doCreateFAQFail(args : {error: String, question: String, answer: String, id: Int}) {
        error_msg = args.error;
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

    public function doDeleteFAQFail(args : {id : Int, error: String}) {
        error_msg = args.error;
        doPrint({id: args.id});
    }

    public function doDeleteFAQSuccess(args : {id : Int}) {
        success_msg = "FAQ entry has been successfully deleted";
        doPrint({id: args.id});
    }

    public function doDeleteCategory(args : {id: Int, parent_id: Int}) {
        this.faq.deleteCategory({category_id: args.id, parent_id: args.parent_id});
    }

    public function doDeleteCategoryFail(args : {id : Int, error: String}) {
        error_msg = args.error;
        doPrint({id: args.id});
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

    public function doEditCategoryFail(args : {error: String}) {
        error_msg = args.error;
        doPrint({id: -1});
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

    public function doEditFAQFail(args : {error: String}) {
        error_msg = args.error;
        doPrint({id: -1});
    }

    public function doEditFAQSuccess(args : {id : Int}) {
        success_msg = "Category has been successfully edited";
        doPrint({id: args.id});
    }
}