package beluga.module.account;

import sys.db.Types.SId;
import haxe.xml.Fast;
import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.account.model.User;
import beluga.module.account.exception.LoginAlreadyExistException;
import sys.db.Types;
import beluga.module.account.SubscribeFailCause;
import haxe.Session;

/**
 * ...
 * @author Masadow
 */
class AccountImpl extends ModuleImpl implements AccountInternal
{

	private static inline var SESSION_USER = "session_user";

	public function new()
	{
		super();
	}

	override public function loadConfig(data : Fast) {
		
	}

	public static function _login(args : {
		login : String,
		password : String
	}) {
		Beluga.getInstance().getModuleInstance(Account).login(args);
	}

	public function login(args : {
		login : String,
		password : String
	}) {
		var user : List<User> = User.manager.dynamicSearch({
			login : args.login,
			hashPassword: haxe.crypto.Md5.encode(args.password)
		});

		if (user.length > 1) {
			//Somethings wrong in database
			beluga.triggerDispatcher.dispatch("beluga_account_login_fail", []);
		} else if (user.length == 0) {
			//login or password wrong
			beluga.triggerDispatcher.dispatch("beluga_account_login_fail", []);
		} else {
			setLoggedUser(user.first());
			beluga.triggerDispatcher.dispatch("beluga_account_login_success", [
				user
			]);
		}
	}

	private function subscribeCheckArgs(args : {
		login : String,
		password : String,
		password_conf : String
	}) : Map < String, List<String> > {
		
		//TODO place user form validation here
		//Also validate that the user is unique with something like this
		//User.manager.dynamicSearch({login : args.login, hashPassword: ahaxe.crypto.Md5.encode(args.password).first() != null;
	
		return new Map < String, List<String> > ();
	}

	public static function _subscribe(args : {
		login : String,
		password : String,
		password_conf : String
	}) {
		Beluga.getInstance().getModuleInstance(Account).subscribe(args);
	}

	public function subscribe(args : {
		login : String,
		password : String,
		password_conf : String
	}) {
		var errorMap = subscribeCheckArgs(args);
		if (Lambda.empty(errorMap)) {
			var user = new User();
			user.login = args.login;
			user.setPassword(args.password);		
			//Save user in db
			user.emailVerified = true;//TODO AB Change when activation mail sended.
			user.subscribeDateTime = Date.now();
			user.insert();
			//TODO AB Send activation mail
			beluga.triggerDispatcher.dispatch("beluga_account_subscribe_success", [
				user
			]);
		} else {
			beluga.triggerDispatcher.dispatch("beluga_account_subscribe_fail", [
				errorMap,
				args
			]);
		}
	}

	public function activateUser(userId : SId) {
		var user = User.manager.get(userId);
		user.emailVerified = true;
		user.update();
	}

	public function setLoggedUser(user : User) : User {
		Session.set(SESSION_USER, user);
		return user;
	}

	public function getLoggedUser() : User {
		return Session.get(SESSION_USER);
	}

	public function isLogged() : Bool {
		return Session.get(SESSION_USER) != null;
	}

}
