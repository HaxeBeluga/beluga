package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;
import beluga.module.account.Account;
import beluga.core.ResourceManager;

import haxe.ds.Option;

class Print extends MttWidget<Faq> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/faq/view/tpl/faqs.mtt");
        super(mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var category_id = switch (mod.category_id) { case Some(id) : id; case None : -1;};
        var entries = mod.getAllFromCategory(category_id);
        var cat = mod.getCategory(category_id);
        var error_msg = (mod.error_msg != "" ? BelugaI18n.getKey(this.i18n, mod.error_msg) : mod.error_msg);
        var success_msg = (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg);
        var parent_id = -1;

        if (cat != null) {
            parent_id = cat.parent_id;
        }
        if (category_id == -1) {
            return {
                faqs : entries,
                categories : entries.categories,
                path : "/beluga/faq/",
                parent_id : parent_id,
                error : error_msg,
                success : success_msg,
                actual_id : category_id,
                user : user,
                base_url : ConfigLoader.getBaseUrl()
            };
        } else {
            var cat = mod.getCategory(category_id);

            if (cat == null) {
                return {
                    faqs : entries,
                    categories : entries.categories,
                    path : "beluga/faq/",
                    parent_id : parent_id,
                    error : error_msg,
                    success : success_msg,
                    actual_id : category_id,
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
                    actual_id : category_id,
                    category_name: cat.name,
                    base_url : ConfigLoader.getBaseUrl()
                };
            }
        }
    }
}