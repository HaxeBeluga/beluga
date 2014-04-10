package beluga.module.wallet.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_wal_currency")
@:id(cu_id)
class Currency extends Object {
    public var cu_id: SId;
    public var cu_name: SString<32>;
    public var cu_rate: SFloat;
}