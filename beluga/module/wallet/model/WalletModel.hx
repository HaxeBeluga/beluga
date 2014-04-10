package beluga.module.wallet.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_wal_wallet")
@:id(wa_id)
class WalletModel extends Object {
    public var wa_id: SId;
    public var wa_user_id: SString<32>;
    public var wa_fund: SFloat;
}