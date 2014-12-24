package beluga.module.faq.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.faq.Faq;
import beluga.I18n;
import beluga.widget.Layout;

class EditFaq extends MttWidget<Faq> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/faq/view/tpl/edit_faq.mtt");
        super(Faq, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/faq/view/locale/edit_faq/", mod.i18n);
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
            base_url : ConfigLoader.getBaseUrl(),
            module_name: "Edit FAQ"
        };
    }
}