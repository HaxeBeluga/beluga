package beluga.module.account;

import haxe.xml.Fast;
import haxe.Session;
import sys.db.Types.SId;
import sys.db.Types;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.account.model.User;
import beluga.module.account.exception.LoginAlreadyExistException;
import beluga.module.account.ESubscribeFailCause;
import beluga.core.macro.MetadataReader;	

enum LastLoginErrorType {
	InternalError;
	WrongLogin;
}

class AccountImpl extends ModuleImpl implements AccountInternal implements MetadataReader {

    private static inline var SESSION_USER = "session_user";
	
	public var trigger = new AccountTrigger();
	public var widget = new AccountWidget();
	
	public var lastLoginError : Null<LastLoginErrorType> = null;
	
	public var loggedUser(get, set) : User;
	
	public var isLogged(get, never) : Bool;
	
	public function new() {
		super();
    }

	override public function initialize(beluga : Beluga) {
	}

    public function logout() : Void {
		Session.remove(SESSION_USER);
		trigger.afterLogout.dispatch();
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
			trigger.loginInternalError.dispatch();
        } else if (user.length == 0) {
            //login or password wrong
            trigger.loginWrongPassword.dispatch();
        } else {
            loggedUser = user.first();
			trigger.loginSuccess.dispatch();
        }
		trigger.afterLogin.dispatch();
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
        //TODO: place user form validation here
        //Also validate that the user is unique with something like this
        //User.manager.dynamicSearch({login : args.login, hashPassword: ahaxe.crypto.Md5.encode(args.password).first() != null;

        return "";
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
            trigger.subscribeSuccess.dispatch({user: user});
        } else {
            trigger.subscribeFail.dispatch({error : error});
        }
    }

	public function getUser(userId : SId) : Null<User> {
		try 
		{
			return User.manager.get(userId);
		}
		catch (e : Dynamic)
		{
			return null;
		}
	}


    public function activateUser(userId : SId) {
        var user = User.manager.get(userId);
        user.emailVerified = true;
        user.update();
    }

    public function set_loggedUser(user : User) : User {
        Session.set(SESSION_USER, user);
        return user;
    }

    public function get_loggedUser() : User {
        return Session.get(SESSION_USER);
    }

    public function get_isLogged() : Bool {
        return Session.get(SESSION_USER) != null;
    }

    public function editEmail(user : User, email : String) : Void {
        if (user != null) {
            user.email = email;
            user.update();
            beluga.triggerDispatcher.dispatch("beluga_account_edit_success", []);
            return;
        }
        beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
    }
}
