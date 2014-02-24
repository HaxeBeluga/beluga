
package beluga.module.account.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;

class AccountApi 
{
	var beluga : Beluga;
	var account : Account;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
		this.account = beluga.getModuleInstance(Account);
	}

	//
	//Login
	//
	public function doLogin() {
		//The function should look like something like this:
		//try {			
		//	beluga.triggerDispatcher.dispatch("login")
		//} catch (err : WrongLoginException) {
		//	doDisplayLoginFailPage();
		//} catch (err : WrongPasswordException) {
		//	doDisplayLoginFailPage();		
		//}
		//doDisplayLoginSuccessPage();
	}

	public function doLoginPage() {
        var loginBox : Widget = account.getWidget("login"); //Generic method for all modules
        loginBox.context.login = "Toto"; // For instance, it would fill the username field with Toto
        var subscribeBox : Widget = account.getWidget("subcribe");
        var html : String = loginBox.render() + subscribeBox.render();
        Sys.print(html); 
	}

	//
	//Subscription
	//
	public function doSubscribe(args : { login : String, password : String }) {
		beluga.triggerDispatcher.dispatch("beluga_account_subscribe");
	}

	public function doDefault() {
        trace("Account default page");
	}

}