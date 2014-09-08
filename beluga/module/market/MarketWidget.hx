package beluga.module.market;

import beluga.module.market.widget.Display;
import beluga.module.market.widget.Cart;
import beluga.module.market.widget.Admin;

class MarketWidget {
    public var cart = new Cart();
    public var display = new Display();
    public var admin = new Admin();

    public function new() {}
}