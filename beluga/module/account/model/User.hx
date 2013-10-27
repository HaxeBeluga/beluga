package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_user")
@:id(id)
@:index(username, unique)
class User extends Object {
	public var id : SId;
	public var username : SString<32>;
//	public var password : 
}