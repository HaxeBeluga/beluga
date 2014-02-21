package beluga.module.account;

import beluga.core.module.Module;
import beluga.module.account.model.User;

/**
 * ...
 * @author Masadow
 */
interface Account extends Module
{

	public function isLogged() : Bool;

	//
	// Mandatory field:
	// 	User.hashPassword
	// 	User.login
	//
	// Return updated user
	//
	public function subscribe(login : String, password : String) : User;

}
