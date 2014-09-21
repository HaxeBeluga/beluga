package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;
import beluga.core.macro.JsonTool;
import beluga.core.BelugaI18n;
import beluga.tool.DynamicTool;

class LoginForm extends MttWidget<AccountImpl> {
    public var i18n : Dynamic;

    public function new (mttfile = "beluga_account_login.mtt") {
        super(Account, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/account/view/local/login/", mod.i18n);
    }

    override private function getContext() {
        var context = {
            isLogged : mod.isLogged,
            loggedUser : mod.loggedUser,
            base_url : ConfigLoader.getBaseUrl(),
            id: MttWidget.id++,
        };
        return context;
    }

    override function getMacro()
    {
        var m = {
            i18n: MttWidget.getI18nKey.bind(_, i18n, _, getContext())
        };
        return m;
    }
}
