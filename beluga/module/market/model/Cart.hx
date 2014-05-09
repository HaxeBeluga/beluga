package beluga.module.market.model;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.market.model.Product;

// Spod
import sys.db.Object;
import sys.db.Types;

@:table("beluga_mar_cart")
@:id(ca_id)
class Cart extends Object {
    public var ca_id: SId;
    public var ca_user_id: SInt;
    public var ca_product_id: SInt;
    public var ca_quantity: SInt;
    @:relation(ca_user_id) public var ca_user: User;
    @:relation(ca_product_id) public var ca_product: Product;
}