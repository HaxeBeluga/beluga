package beluga.module.wallet.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.wallet.Wallet;

class Show extends MttWidget<WalletImpl> {

    public function new (mttfile = "beluga_wallet_show.mtt") {
        super(Wallet, mttfile);
    }

    override private function getContext() {
        var context = mod.getShowContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}