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

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.faq = beluga.getModuleInstance(Faq);

        this.faq.triggers.defaultPage.add(this.doDefault);
        this.faq.triggers.createCategorySuccess.add(this.doPrint);
        this.faq.triggers.createCategoryFail.add(this.doRedirectCreateCategory);
        this.faq.triggers.deleteCategorySuccess.add(this.doPrint);
        this.faq.triggers.deleteCategoryFail.add(this.doPrint);
        this.faq.triggers.editCategorySuccess.add(this.doPrint);
        this.faq.triggers.editCategoryFail.add(this.doPrint);

        this.faq.triggers.createSuccess.add(this.doPrint);
        this.faq.triggers.createFail.add(this.doRedirectCreateFAQ);
        this.faq.triggers.deleteSuccess.add(this.doPrint);
        this.faq.triggers.deleteFail.add(this.doPrint);
        this.faq.triggers.editSuccess.add(this.doPrint);
        this.faq.triggers.editFail.add(this.doPrint);
    }

    public function doDefault() {
        doPrint({id: -1});
    }

    public function doPrint(args : {id : Int}) {
        var widget = this.faq.getWidget("faqs");
        widget.context = faq.getPrintContext(args.id);

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doRedirectCreateCategory(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_category");

        widget.context = faq.getCreateCategoryContext(args.category_id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doRedirectCreateFAQ(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_faq");

        widget.context = faq.getCreateContext(args.category_id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doCreateCategory(args : {name : String, parent : Int}) {
        this.faq.createCategory(args);
    }

    public function doCreateFAQ(args : {question : String, answer : String, parent : Int}) {
        this.faq.createFAQ({question : args.question, answer: args.answer, category_id: args.parent});
    }

    public function doDeleteFAQ(args : {id: Int, category_id: Int}) {
        this.faq.deleteFAQ({question_id: args.id, category_id: args.category_id});
    }

    public function doDeleteCategory(args : {id: Int, parent_id: Int}) {
        this.faq.deleteCategory({category_id: args.id, parent_id: args.parent_id});
    }

    public function doRedirectEditCategory(args : {id: Int}) {
        var widget = this.faq.getWidget("edit_category");
        var cat = faq.getCategory(args.id);

        if (cat == null) {
            doPrint({id: args.id});
            return;
        }
        widget.context = faq.getEditContext(args.id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doEditCategory(args : {category_id: Int, name: String}) {
        this.faq.editCategory(args);
    }

    public function doRedirectEditFAQ(args : {id: Int}) {
        if (!faq.redirectEditFAQ(args.id))
            doPrint({id: -1});
        else {
            var widget = this.faq.getWidget("edit_faq");

            widget.context = faq.getEditFAQContext(args.id);
            var html = Renderer.renderDefault("page_faq", "FAQ", {
                faqWidget: widget.render()
            });
            Sys.print(html);
        }
    }

    public function doEditFAQ(args : {faq_id: Int, question: String, answer: String}) {
        this.faq.editFAQ(args);
    }
}