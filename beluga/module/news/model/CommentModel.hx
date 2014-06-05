package beluga.module.news.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;
import beluga.module.news.model.NewsModel;

@:table("beluga_news_comment")
@:id(id)
class CommentModel extends Object {
    public var id : SId;
    public var news_id : SInt;
    public var text : SText;
    public var user_id : SInt;
    public var creationDate : SDateTime;
    @:relation(user_id) public var user : User;
    @:relation(news_id) public var news : NewsModel;
}