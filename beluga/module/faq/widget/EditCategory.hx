package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;

class EditCategory extends MttWidget<FaqImpl> {

    public function new (mttfile = "beluga_faq_edit_category.mtt") {
        super(Faq, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/locale/edit_category/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var cat = mod.getCategory(mod.category_id);

        return {
            path : "/beluga/faq/",
            error : (mod.error_msg != "" ? BelugaI18n.getKey(this.i18n, mod.error_msg) : mod.error_msg),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            category_id : mod.category_id,
            name: cat.name,
            parent: if (cat != null) { cat.parent_id; } else { -1; },
            base_url : ConfigLoader.getBaseUrl()
        };
    }
}