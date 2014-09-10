package beluga.module.market;

// beluga core
import beluga.core.module.Module;

// beluga mods
import beluga.module.market.model.Product;
import beluga.module.market.MarketWidget;

// haxe
import haxe.ds.Option;

interface Market extends Module {
    public var triggers: MarketTrigger;
    public var widgets: MarketWidget;

    // widget functions
    public function display(): Void;
    public function admin(): Void;
	#if (php || neko)
    public function cart(): Void;
    public function addProductToCart(args: { id: Int }): Void;
    public function removeProductInCart(args: { id: Int }): Void;
    public function checkoutCart(): Void;
	#end

    // widget context functions
    public function getDisplayContext(): Dynamic;
    public function getAdminContext(): Dynamic;
	#if (php || neko)
    public function getCartContext(): Dynamic;
	#end

    public function getProductList(): List<Dynamic>;
    public function getProductFromId(id: Int): Option<Product>;
}