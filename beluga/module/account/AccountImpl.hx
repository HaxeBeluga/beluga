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
	
	public static var loggedUser(get, set) : User;
	
	public function new()
	{
		super();
	}

	override public function loadConfig(data : Fast) {
		
	}

	public static function login(args : {
		login : String,
		password : String
	}) {
		var user : List<User> = User.manager.dynamicSearch({
			login : args.login,
			hashPassword: haxe.crypto.Md5.encode(args.password)
		});

		if (user.length > 1) {
			//Somethings wrong in database
		} else if (user.length == 0) {
			//login or password wrong
		} else {
			set_loggedUser(user.first());
		}
	}

	private static function subscribeCheckArgs(args : {
		login : String,
		password : String,
		password_conf : String
	}) : Map < String, List<String> > {
		
		//TODO place user form validation here
		//Also validate that the user is unique with something like this
		//User.manager.dynamicSearch({login : args.login, hashPassword: ahaxe.crypto.Md5.encode(args.password).first() != null;
	
		return new Map < String, List<String> > ();
	}
	
	//
	// Mandatory field:
	// 	params.password
	// 	params.password_conf
	//  params.
	//
	// Return updated user
	//
	public static function subscribe(args : {
		login : String,
		password : String,
		password_conf : String
	}) {
		var beluga = Beluga.getInstance();
		var errorMap = subscribeCheckArgs(args);
		if (errorMap.lenght == 0) {
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
				args.login,
				args.password
			]);
		}
	}

	public function activate(userId : SId) {
		var user = User.manager.get(userId);
		user.emailVerified = true;
		user.update();
	}

	public static function set_loggedUser(user : User) : User {
		Session.set(SESSION_USER, user);
		return user;
	}

	public static function get_loggedUser() : User {
		return Session.get(SESSION_USER);
	}

	public function isLogged() : Bool {
		return Session.get(SESSION_USER) != null;
	}

}
