package beluga.module.market.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.market.Market;

class Cart extends MttWidget<MarketImpl> {

    public function new (mttfile = "beluga_market_cart.mtt") {
        super(Market, mttfile);
    }

    override private function getContext(): Dynamic{
        return mod.getCartContext();
    }
}