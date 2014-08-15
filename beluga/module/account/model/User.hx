package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_user")
@:id(id)
@:index(login, unique)
class User extends Object {
    public var id : SId;
    public var login : SString<32>;
    public var hashPassword : SString<32>;
    public var subscribeDateTime : SDateTime;
    public var emailVerified : SBool;
    public var isAdmin : SBool;
    public var isBan: SBool;
    public var sponsor_id: SInt;
    public var email : SString<128>;

    @:relation(sponsor_id) public var sponsor : User;

    public function setPassword(password : String) {
        hashPassword = haxe.crypto.Md5.encode(password);
    }

}