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
        this.faq.triggers.createCategorySuccess.add(this.print);
        this.faq.triggers.createCategoryFail.add(this.redirectCreateCategory);
        this.faq.triggers.deleteCategorySuccess.add(this.print);
        this.faq.triggers.deleteCategoryFail.add(this.print);
        this.faq.triggers.editCategorySuccess.add(this.print);
        this.faq.triggers.editCategoryFail.add(this.print);
        this.faq.triggers.createSuccess.add(this.print);
        this.faq.triggers.createFail.add(this.redirectCreateFAQ);
        this.faq.triggers.deleteSuccess.add(this.print);
        this.faq.triggers.deleteFail.add(this.print);
        this.faq.triggers.editSuccess.add(this.print);
        this.faq.triggers.editFail.add(this.print);
        this.faq.triggers.redirectCreateFAQ.add(this.redirectCreateFAQ);
        this.faq.triggers.redirectCreateCategory.add(this.redirectCreateCategory);
        this.faq.triggers.print.add(this.print);
        this.faq.triggers.redirectEditCategory.add(this.redirectEditCategory);
        this.faq.triggers.redirectEditFAQ.add(this.redirectEditFAQ);
    }

    public function doDefault() {
        print({id: -1});
    }

    public function print(args : {id : Int}) {
        var widget = this.faq.getWidget("faqs");
        widget.context = faq.getPrintContext(args.id);

        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function redirectCreateCategory(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_category");

        widget.context = faq.getCreateCategoryContext(args.category_id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function redirectCreateFAQ(args : {category_id : Int}) {
        var widget = this.faq.getWidget("create_faq");

        widget.context = faq.getCreateContext(args.category_id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function redirectEditCategory(args : {id: Int}) {
        var widget = this.faq.getWidget("edit_category");
        var cat = faq.getCategory(args.id);

        if (cat == null) {
            print({id: args.id});
            return;
        }
        widget.context = faq.getEditCategoryContext(args.id);
        var html = Renderer.renderDefault("page_faq", "FAQ", {
            faqWidget: widget.render()
        });
        Sys.print(html);
    }

    public function redirectEditFAQ(args : {id: Int}) {
        if (!faq.redirectEditFAQ(args.id))
            print({id: -1});
        else {
            var widget = this.faq.getWidget("edit_faq");

            widget.context = faq.getEditFAQContext(args.id);
            var html = Renderer.renderDefault("page_faq", "FAQ", {
                faqWidget: widget.render()
            });
            Sys.print(html);
        }
    }
}