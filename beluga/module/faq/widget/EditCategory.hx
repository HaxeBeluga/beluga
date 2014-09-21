package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;

class EditCategory extends MttWidget<FaqImpl> {

    public function new (mttfile = "beluga_faq_edit_category.mtt") {
        super(Faq, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/local/edit_category/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var cat = mod.getCategory(mod.category_id);

        /*if (cat == null) {
            doEditCategoryFail({error : "Unknown category"});
            return;
        }*/
        return {
            path : "/beluga/faq/",
            error : if (mod.error_msg != "") { BelugaI18n.getKey(this.i18n, mod.error_msg); } else { mod.error_msg; },
            success : if (mod.success_msg != "") { BelugaI18n.getKey(this.i18n, mod.success_msg); } else {mod.success_msg; },
            category_id : mod.category_id,
            name: cat.name,
            parent: if (cat != null) { cat.parent_id; } else { -1; },
            base_url : ConfigLoader.getBaseUrl()
        };
    }
}