package beluga.module.news.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.news.News;
import beluga.module.account.Account;
import beluga.module.news.model.NewsModel;

class Edit extends MttWidget<NewsImpl> {

    public function new(mttfile = "beluga_news_edit.mtt") {
        super(News, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/news/view/locale/edit/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            // here is a trick to replace the Edit widget by the Default widget
            var ret = mod.widgets.news.getContext();

            ret.other = mod.widgets.news.render();
            return ret;
        }
        if (!mod.canEdit(mod.actual_news_id, user.id)) {
            var ret = mod.widgets.print.getContext();

            ret.other = mod.widgets.print.render();
            return ret;
        } else {
            return {
                path : "/beluga/news/",
                news : NewsModel.manager.get(mod.actual_news_id),
                error : mod.getErrorString(mod.error_id)
            };
        }
    }
}