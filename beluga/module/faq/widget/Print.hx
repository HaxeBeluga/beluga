package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;
import beluga.module.account.Account;

class Print extends MttWidget<FaqImpl> {

    public function new (mttfile = "beluga_faq_faqs.mtt") {
        super(Faq, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var entries = mod.getAllFromCategory(mod.category_id);
        var cat = mod.getCategory(mod.category_id);
        var error_msg = (mod.error_msg != "" ? BelugaI18n.getKey(this.i18n, mod.error_msg) : mod.error_msg);
        var success_msg = (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg);
        var parent_id = mod.parent_id;

        if (cat != null) {
            parent_id = cat.parent_id;
        }
        if (mod.category_id == -1) {
            return {
                faqs : entries,
                categories : entries.categories,
                path : "/beluga/faq/",
                parent_id : parent_id,
                error : error_msg,
                success : success_msg,
                actual_id : mod.category_id,
                user : user,
                base_url : ConfigLoader.getBaseUrl()
            };
        } else {
            var cat = mod.getCategory(mod.category_id);

            if (cat == null) {
                return {
                    faqs : entries,
                    categories : entries.categories,
                    path : "beluga/faq/",
                    parent_id : parent_id,
                    error : error_msg,
                    success : success_msg,
                    actual_id : mod.category_id,
                    user : user,
                    base_url : ConfigLoader.getBaseUrl()
                };
            } else {
                return {
                    faqs : entries,
                    categories : entries.categories,
                    path : "/beluga/faq/",
                    user : user,
                    parent_id : parent_id,
                    error : error_msg,
                    success : success_msg,
                    actual_id : mod.category_id,
                    category_name: cat.name,
                    base_url : ConfigLoader.getBaseUrl()
                };
            }
        }
    }
}