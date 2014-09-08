package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;

class SubscribeForm extends MttWidget {
    var acc : Account;

    public function new (mttfile = "beluga_account_subscribe.mtt") {
        super(mttfile);
        acc = Beluga.getInstance().getModuleInstance(Account);
    }

    override private function getContext() {
        var context = {
            base_url : ConfigLoader.getBaseUrl(),
            id: MttWidget.id++,
        };
        return context;
    }

}