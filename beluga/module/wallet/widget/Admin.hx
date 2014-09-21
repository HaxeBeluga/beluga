package beluga.module.wallet.widget;

import beluga.core.Beluga;
import beluga.core.BelugaI18n;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.wallet.Wallet;

class Admin extends MttWidget<WalletImpl> {

    public function new (mttfile = "beluga_wallet_admin.mtt") {
        super(Wallet, mttfile);
        this.i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/show/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        return mod.getAdminContext();
    }
}