package beluga.module.market.model;

import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_mar_product")
class Product extends Object {
    public var id: SId;
    public var stock: SInt;
    public var name: STinyText;
    public var price: SFloat;
    public var desc : SText;
}