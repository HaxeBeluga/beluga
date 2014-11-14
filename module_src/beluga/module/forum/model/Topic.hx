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

import beluga.module.forum.model.CategoryModel;
import beluga.module.forum.model.Message;
import beluga.module.account.model.User;

@:table("beluga_frm_topic")
@:id(id)
@:build(beluga.Database.registerModel())
class Topic extends Object {
    public var id : SId;
    public var category_id: SInt;
    public var title : STinyText;
    public var creator_id: SInt;
    public var is_solved: SBool;
    public var date: SDate;
    public var last_message_id: SInt;

    @:relation(category_id) public var category : CategoryModel;
    @:relation(creator_id) public var creator : User;
    @:relation(last_message_id) public var last_message : Message;
}