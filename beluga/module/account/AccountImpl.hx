package beluga.module.account;

import sys.db.Types.SId;
import haxe.xml.Fast;
import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.account.model.User;
import beluga.module.account.exception.LoginAlreadyExistException;
import sys.db.Types;
import beluga.module.account.ESubscribeFailCause;
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

	public static function _logout() {
		Beluga.getInstance().getModuleInstance(Account).logout();
	}

	public function logout() {
		Session.set(SESSION_USER, null);
		beluga.triggerDispatcher.dispatch("beluga_account_logout", []);
	}

	@trigger("beluga_account_login")
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
		password_conf : String,
		email : String
	}) : String {
		
		if (args.login == "") {
			return "invalid login";
		}
		if (args.password == "" || args.password_conf == "") {
			return "missing password";
		}
		if (args.password != args.password_conf) {
			return "passwords don't match";
		}
		
		for (tmp in User.manager.dynamicSearch( {login : args.login} )) {
			return "login already used";
		}
		//TODO place user form validation here
		//Also validate that the user is unique with something like this
		//User.manager.dynamicSearch({login : args.login, hashPassword: ahaxe.crypto.Md5.encode(args.password).first() != null;
	
		return "";
	}

	public static function _subscribe(args : {
		login : String,
		password : String,
		password_conf : String,
		email : String
	}) {
		Beluga.getInstance().getModuleInstance(Account).subscribe(args);
	}

	public function subscribe(args : {
		login : String,
		password : String,
		password_conf : String,
		email : String
	}) {
		var error = subscribeCheckArgs(args);
		if (error == "") {
			var user = new User();
			user.login = args.login;
			user.setPassword(args.password);		
			//Save user in db
			user.emailVerified = true;//TODO AB Change when activation mail sended.
			user.subscribeDateTime = Date.now();
			user.email = args.email;
			user.insert();
			//TODO AB Send activation mail
			beluga.triggerDispatcher.dispatch("beluga_account_subscribe_success", [
				user
			]);
		} else {
			beluga.triggerDispatcher.dispatch("beluga_account_subscribe_fail", [
				error
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

	public function _showUser(args: { id: Int}): Void {
		Beluga.getInstance().getModuleInstance(Account).showUser(args);
	}

	public function showUser(args: { id: Int}): Void {
		beluga.triggerDispatcher.dispatch("beluga_account_show_user", [args]);
	}

	public function edit(email : String) : Void {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			user.email = email;
			user.update();
			beluga.triggerDispatcher.dispatch("beluga_account_edit_success", []);
			return;
		}
		beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
	}
}
