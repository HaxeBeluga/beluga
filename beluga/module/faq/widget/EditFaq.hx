package beluga.module.faq.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.core.BelugaI18n;
import beluga.core.ResourceManager;

class EditFaq extends MttWidget<FaqImpl> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/faq/view/tpl/edit_faq.mtt");
        super(mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/faq/view/locale/edit_faq/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var faq = mod.getFAQ(switch (mod.faq_id) { case Some(id) : id; case None : -1;});

        return {
            path : "/beluga/faq/",
            error : (mod.error_msg != "" ? BelugaI18n.getKey(this.i18n, mod.error_msg) : mod.error_msg),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            parent : switch (mod.category_id) { case Some(id) : id; case None : -1;},
            id: switch (mod.faq_id) { case Some(id) : id; case None : -1;},
            name: faq.question,
            answer: faq.answer,
            base_url : ConfigLoader.getBaseUrl()
        };
    }
}