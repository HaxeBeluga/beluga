package beluga.module.market.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.market.Market;

class Admin extends MttWidget<MarketImpl> {

    public function new (mttfile = "beluga_market_admin.mtt") {
        super(Market, mttfile);
    }

    override private function getContext(): Dynamic {
        return mod.getAdminContext();
    }
}