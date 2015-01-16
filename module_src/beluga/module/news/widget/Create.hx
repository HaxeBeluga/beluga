package beluga.module.news.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.news.News;
import beluga.module.account.Account;
import beluga.widget.Layout;

class Create extends MttWidget<News> {

    public function new (?layout : Layout) {
        if (layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/news/view/tpl/create.mtt");
        super(News, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/news/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            // here is a trick to replace the Create widget by the Default widget
            var ret = mod.widgets.news.getContext();

            ret.other = mod.widgets.news.render();
            return ret;
        }
        return {
            path : "/beluga/news/",
            title : mod.title,
            error : mod.getErrorString(mod.error_id),
            data : mod.news_text,
            module_name: "Create news"
        };
    }
}