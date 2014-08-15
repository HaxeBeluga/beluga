package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_blacklist")
@:id(id)
class BlackList extends Object {
    public var id : SId;
    public var user_id : SInt;
    public var blacklisted_id : SInt;

    @:relation(user_id) public var user : User;
    @:relation(blacklisted_id) public var blacklisted : User;
}