package beluga.module.news.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_news_news")
@:id(id)
class NewsModel extends Object {
    public var id : SId;
    public var title : STinyText;
    public var text : SText;
    public var user_id : SInt;
    public var creationDate : SDateTime;
    @:relation(user_id) public var user : User;
}