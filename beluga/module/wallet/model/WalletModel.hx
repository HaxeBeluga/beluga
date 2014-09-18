package beluga.module.wallet.model;

// beluga mods
import beluga.module.account.model.User;

//haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_wallet")
class WalletModel extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var fund: SFloat;
    @:relation(user_id)
    public var user: User;
}