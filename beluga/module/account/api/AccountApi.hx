
package beluga.module.account.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;

class AccountApi 
{
	var beluga : Beluga;
	var account : Account;

	public function new(beluga : Beluga, account : Account) {
		this.beluga = beluga;
		this.account = account;
	}

	public function doLogin() {
		//try {			
		//	beluga.triggerDispatcher.dispatch("login")
		//} catch (err : WrongLoginException) {
		//	doDisplayLoginFailPage();
		//} catch (err : WrongPasswordException) {
		//	doDisplayLoginFailPage();		
		//}
		//doDisplayLoginSuccessPage();
	}

	public function doDisplayLoginPage() {
		var acc = beluga.getModuleInstance(Account);
        var loginBox : Widget = acc.getWidget("login"); //Generic method for all modules
        loginBox.context.login = "Toto"; // For instance, it would fill the username field with Toto
        var subscribeBox : Widget = acc.getWidget("subscribe");
        var html : String = loginBox.render() + subscribeBox.render();
        Sys.print(html);
	}

	public function doDisplayLoginSuccessPage() {
	}

	public function doDisplayLoginFailPage() {
	}

}