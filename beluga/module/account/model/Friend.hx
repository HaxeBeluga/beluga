package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_friend")
@:id(id)
class Friend extends Object {
    public var id : SId;
    public var user_id : SInt;
    public var friend_id : SInt;

    @:relation(user_id) public var user : User;
    @:relation(friend_id) public var friend : User;
}