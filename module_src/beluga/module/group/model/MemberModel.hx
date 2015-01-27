// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;
import beluga.module.group.model.GroupModel;

@:id(id, group_id, user_id)
@:table("beluga_grp_member")
@:build(beluga.Database.registerModel())
class MemberModel extends Object {
    public var id: SId;
    @:relation(group_id)
    public var group: GroupModel;
    @:relation(user_id)
    public var user : User;

    public function new() { super(); }

    public function init(group: GroupModel, user: User) {
        this.group = group;
        this.user = user;
        return this;
    }
}