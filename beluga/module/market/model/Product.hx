package beluga.module.market.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_mar_product")
@:id(pr_id)
class Product extends Object {
    public var pr_id: SId;
    public var pr_stock: SInt;
    public var pr_name: STinyText;
    public var pr_price: SFloat;
    public var pr_desc : SText;
}