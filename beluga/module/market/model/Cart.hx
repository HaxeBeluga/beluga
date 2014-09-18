package beluga.module.market.model;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.market.model.Product;

// Spod
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_mar_cart")
class Cart extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var product_id: SInt;
    public var quantity: SInt;
    @:relation(user_id)
    public var user: User;
    @:relation(product_id)
    public var product: Product;
}