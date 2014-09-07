package beluga.module.market.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.market.Market;

class MarketApi {
    public var beluga : Beluga;
    public var module : Market;

    public function new() {}

    public function doDisplay(): Void {
        module.display();
    }

    public function doAdmin(): Void {
        module.admin();
    }

    public function doCart(): Void {
        module.cart();
    }

    public function doAddProductToCart(args: { id: Int }): Void {
        module.addProductToCart(args);
    }

    public function doRemoveProductInCart(args: { id: Int }): Void {
        module.removeProductInCart(args);
    }

    public function doCheckoutCart(): Void {
        module.checkoutCart();
    }

    public function doDefault(): Void {
        trace("Market default page");
    }
}