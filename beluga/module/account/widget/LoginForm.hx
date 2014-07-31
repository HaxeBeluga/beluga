package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;

/**
 * ...
 * @author brissa_A
 */
class LoginForm extends MttWidget
{
	var acc : Account;
	
	public var globalErrorKey(default, default):String;
	public var globalSuccessKey(default, default):String;
	public var loginErrorKeys(default, default): Array<String>;
	public var passwordErrorKeys(default, default): Array<String>;

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
			globalErrorKey : this.globalErrorKey,
			globalSuccessKey : this.globalSuccessKey,
			loginErrorKeys : this.loginErrorKeys,
			passwordErrorKeys : this.passwordErrorKeys
		};
		trace(context.loginErrorKeys[0]);
		return context;
	}

}
