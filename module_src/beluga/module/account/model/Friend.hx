// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_friend")
@:id(id)
@:build(beluga.Database.registerModel())
class Friend extends Object {
    public var id : SId;
    public var user_id : SInt;
    public var friend_id : SInt;

    @:relation(user_id) public var user : User;
    @:relation(friend_id) public var friend : User;
}