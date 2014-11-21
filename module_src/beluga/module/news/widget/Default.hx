package beluga.module.news.widget;

import sys.db.Types;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.news.News;
import beluga.module.news.model.NewsModel;
import beluga.module.account.Account;
import beluga.widget.Layout;

class NewsList {
    public var title : String;
    public var text : String;
    public var id : Int;
    public var pos : Int;
    public var creationDate : SDateTime;

    public function new(title : String, text : String, id : Int, position : Int, creationDate: SDateTime) {
        this.title = title;
        this.text = text;
        this.id = id;
        this.pos = position;
        this.creationDate = creationDate;
        // 200 is the number of characters, used as preview for display
        if (text.length > 200) {
            text = text.substr(0, 200) + "...";
        }
    }
}

class Default extends MttWidget<News> {

    public function new (?layout : Layout) {
        if(layout == null) layout = Layout.newFromPath("/beluga/module/news/view/tpl/default.mtt");
        super(News, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/news/view/locale/default/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var all_news = mod.getAllNews();
        var news_array = new Array<NewsList>();
        var pos = 0;

        for (news in all_news) {
            news_array.push(new NewsList(news.title, news.text, news.id, pos, news.creationDate));
            pos = pos ^ 1;
        }
        return {
            news : news_array,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/news/",
            user: user
        };
    }
}