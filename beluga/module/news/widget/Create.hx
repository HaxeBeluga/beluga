package beluga.module.news.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.news.News;
import beluga.module.account.Account;

class Create extends MttWidget<NewsImpl> {

    public function new(mttfile = "beluga_news_create.mtt") {
        super(News, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/news/view/locale/create/", mod.i18n);
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
            data : mod.news_text
        };
    }
}