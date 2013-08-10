package ;

import beluga.core.Beluga;
import beluga.module.account.Account;

/**
 * Beluga #1
 * Load the account class
 * Use it to generate login form, subscribe form, logged homepage
 * @author Masadow
 */

class Main 
{
	static var beluga = new Beluga();

	static function main() 
	{
		var acc = beluga.getModuleInstance(Account, "");
//		acc.test();
		trace(acc);
//		AccountImpl.getInstance().test();
//		trace(acc.a);
	}

	public static function index(isLogged : Bool) {
		if (!isLogged)
			beluga.webDispatcher.redirect('login');
	}

}