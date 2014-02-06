
package beluga.module.account.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.module.account.exception.LoginAlreadyExistException;

class AccountApi 
{
	var beluga : Beluga;
	var account : Account;

	public function new(beluga : Beluga, account : Account) {
		this.beluga = beluga;
		this.account = account;
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
		var acc = beluga.getModuleInstance(Account);
        var loginBox : Widget = acc.getWidget("login"); //Generic method for all modules
        loginBox.context.login = "Toto"; // For instance, it would fill the username field with Toto
        var subscribeBox : Widget = acc.getWidget("subscribe");
        var html : String = loginBox.render() + subscribeBox.render();
        Sys.print(html);
	}

	public function doLoginSuccessPage() {
	}

	public function doLoginFailPage() {
	}



	//
	//Subscription
	//

	public function doSubcribe() {
		var user = new User();
		user.login = "user" + Std.random(10);
		user.setPassword("password");
		try {
			account.subscribe(user);
			trace("success !");
		} catch (err : LoginAlreadyExistException) {
			trace("Error when subcrive the login is already used !");
		}
	}

}