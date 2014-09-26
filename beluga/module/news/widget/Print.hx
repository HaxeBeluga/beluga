package beluga.module.news.widget;

import sys.db.Types;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.news.News;
import beluga.module.account.Account;
import beluga.module.news.model.NewsModel;

class NewsData {
    public var text : String;
    public var login : String;
    public var date : SDateTime;
    public var com_id : Int;

    public function new(t : String, l : String, d : SDateTime, c : Int) {
        text = t;
        login = l;
        date = d;
        com_id = c;
    }
}

class Print extends MttWidget<NewsImpl> {

    public function new(mttfile = "beluga_news_print.mtt") {
        super(News, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/news/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (!mod.canPrint(mod.actual_news_id)) {
            return mod.widgets.news.render();
        }
        var all_comments = mod.getComments(mod.actual_news_id);
        var comments_list = new Array<NewsData>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var news = NewsModel.manager.get(mod.actual_news_id);

        for (comment in all_comments) {
            comments_list.push(new NewsData(comment.text, comment.user.login, comment.creationDate, comment.id));
        }

        return {
            news : news,
            comments : comments_list,
            path : "/beluga/news/",
            user : user,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg)
        };
    }
}