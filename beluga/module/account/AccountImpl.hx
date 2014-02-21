package beluga.module.account;

import sys.db.Types.SId;
import haxe.xml.Fast;
import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.account.model.User;
import beluga.module.account.exception.LoginAlreadyExistException;
import sys.db.Types;

/**
 * ...
 * @author Masadow
 */
class AccountImpl extends ModuleImpl implements AccountInternal
{

	public function new()
	{
		super();
	}

	override public function loadConfig(data : Fast) {
		
	}

	public function login(login : String, password : String) {
		var user = User.manager.dynamicSearch({
			login : login,
			hashPassword: haxe.crypto.Md5.encode(password)
		});

		if (user == null) {
			//throw
		}
		//TODO AB mettre utilissateur en session
	}

	//
	// Mandatory field:
	// 	User.hashPassword
	// 	User.login
	//
	// Return updated user
	//
	public function subscribe(login : String, password : String) : User {
		//Check args
		var user = new User();
		user.login = login;
		user.setPassword(password);

		var userCheck = User.manager.dynamicSearch({login : user.login, hashPassword: user.hashPassword}).first();
		if (userCheck == null) {
			//Save user in db
			user.emailVerified = true;//TODO AB Change when activation mail sended.
			user.subscribeDateTime = Date.now();
			user.insert();
			//TODO AB Send activation mail
			beluga.triggerDispatcher.dispatch("SubscribeSuccess");
		} else {
			beluga.triggerDispatcher.dispatch("SubscribeFail");
		}
		return user;
	}

	public function activate(userId : SId) {
		//var user = User.manager.get(userId);
		//user.emailVerified = true;
		//user.update();
	}

	@:option(password)
	@:return(true)
	public static function checkPassword(password : String) : Bool {
		return false;
	}

	public function getLoggedUser() : User {
		//TODO AB return user in session
		return null;
	}

	public function isLogged() : Bool {
		//TODO AB return si l'utilisateur est en session
		return false;
	}

}
