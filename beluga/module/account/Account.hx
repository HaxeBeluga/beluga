package beluga.module.account;

import beluga.core.module.Module;
import beluga.module.account.model.User;

/**
 * ...
 * @author Masadow
 */
interface Account extends Module
{
	public function subscribe(args : {
		login : String,
		password : String,
		password_conf : String,
		email : String
	}) : Void;
	
	public function login(args : {
		login : String,
		password : String
	}) : Void;

	public function logout() : Void;

	public function setLoggedUser(user : User) : User;

	public function getLoggedUser() : User;

	public function isLogged() : Bool;
}
