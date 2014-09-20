package beluga.module.wallet.model;

// beluga mods
import beluga.module.wallet.model.Currency;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_sitecurrency")
class SiteCurrency extends Object {
    public var id: SId;
    public var currency_id: SInt;
    @:relation(currency_id)
    public var currency: Currency;
}