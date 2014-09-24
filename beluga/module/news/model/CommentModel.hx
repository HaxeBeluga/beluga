// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

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