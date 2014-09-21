package beluga.module.wallet.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.wallet.Wallet;

class Show extends MttWidget<WalletImpl> {

    public function new (mttfile = "beluga_wallet_show.mtt") {
        super(mttfile);
        this.i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/show/", mod.i18n);
    }

    override private function getContext() {
        var context = mod.getShowContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}