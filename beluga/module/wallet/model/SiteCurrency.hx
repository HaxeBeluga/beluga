package beluga.module.wallet.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_wal_sitecurrency")
@:id(si_id)
class SiteCurrency extends Object {
    public var si_id: SId;
    public var si_cu_id: SInt;
}