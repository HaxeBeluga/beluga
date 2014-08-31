package beluga.module.wallet.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.wallet.Wallet;

class Admin extends MttWidget {
    var mod : Wallet;

    public function new (mttfile = "beluga_wallet_admin.mtt") {
        super(mttfile);
        mod = Beluga.getInstance().getModuleInstance(Wallet);
    }

    override private function getContext() {
        var context = mod.getAdminContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}