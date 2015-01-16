package beluga.module.news.widget;

import sys.db.Types;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.news.News;
import beluga.module.account.Account;
import beluga.module.news.model.NewsModel;
import beluga.widget.Layout;

class NewsData {
    public var text : String;
    public var login : String;
    public var date : SDateTime;
    public var com_id : Int;

    public function new(text : String, login : String, date : SDateTime, comment_id : Int) {
        this.text = text;
        this.login = login;
        this.date = date;
        this.com_id = comment_id;
    }
}

class Print extends MttWidget<News> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/news/view/tpl/print.mtt");
        super(News, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/news/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (!mod.canPrint(mod.actual_news_id)) {
            // here is a trick to replace the Print widget by the Default widget
            var ret = mod.widgets.news.getContext();

            ret.other = mod.widgets.news.render();
            return ret;
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
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            module_name: "News"
        };
    }
}