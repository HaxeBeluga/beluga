package beluga.module.wallet.model;

import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_currency")
class Currency extends Object {
    public var id: SId;
    public var name: SString<32>;
    public var rate: SFloat;

    public function convertToReal(value: Float): Float {
        return value / this.rate;
    }

    public function convertToCurrency(value: Float): Float {
        return value * this.rate;
    }
}