// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.forum.model.Topic;
import beluga.module.account.model.User;

@:table("beluga_frm_message")
@:id(id)
@:build(beluga.Database.registerModel())
class Message extends Object {
    public var id : SId;
    public var author_id: SInt;
    public var topic_id: SInt;
    public var text : SText;
    public var date: SDate;

    @:relation(author_id) public var author : User;
    @:relation(topic_id) public var topic : Topic;
}