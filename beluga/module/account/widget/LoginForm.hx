package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;
import beluga.core.macro.JsonTool;
import beluga.core.BelugaI18n;

class LoginForm extends MttWidget {
    var acc : Account;

	public static var i18n = BelugaI18n.loadI18nFolder("/module/account/view/local/login/");

    public function new (mttfile = "beluga_account_login.mtt") {
        super(mttfile);
        acc = Beluga.getInstance().getModuleInstance(Account);
    }

    override private function getContext() {
        var context = {
            isLogged : acc.isLogged,
            loggedUser : acc.loggedUser,
            base_url : ConfigLoader.getBaseUrl(),
            id: MttWidget.id++,
        };
        return context;
    }

	override function getMacro() 
	{
		var m = {
			i18n: MttWidget.getI18nKey.bind(_, i18n, _)
		};
		return m;
	}
}
