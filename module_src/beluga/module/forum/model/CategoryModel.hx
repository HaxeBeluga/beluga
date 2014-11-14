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

import beluga.module.account.model.User;
import beluga.module.forum.model.Message;

@:table("beluga_frm_category")
@:id(id)
@:build(beluga.Database.registerModel())
class CategoryModel extends Object {
    public var id : SId;
    public var parent_id: SInt;
    public var name : STinyText;
    public var description: SText;
    public var creator_id: SInt;
    public var last_message_id: SInt;

    @:relation(parent_id) public var parent : CategoryModel;
    @:relation(creator_id) public var creator : User;
    @:relation(last_message_id) public var last_message : Message;
}