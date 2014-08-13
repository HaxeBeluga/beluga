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

	public var triggers = new AccountTrigger();
	public var widgets : AccountWidget;

	public var lastLoginError : Null<LastLoginErrorType> = null;

	public var loggedUser(get, set) : User;

	public var isLogged(get, never) : Bool;

	public function new() {
		super();
    }

	override public function initialize(beluga : Beluga) {
		this.widgets = new AccountWidget();
	}

    public function logout() : Void {
		Session.remove(SESSION_USER);
		triggers.afterLogout.dispatch();
    }

    public function login(args : {
        login : String,
        password : String
    }) {
        var user : List<User> = User.manager.dynamicSearch({login : args.login});

        if (user.length > 1) {
            //Somethings wrong in database
            beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Something's wrong in database"}]);
        } else if (user.length == 0) {
            //login wrong
            beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Unknown user"}]);
        } else {
            if (user.first().hashPassword != haxe.crypto.Md5.encode(args.password)) {
                beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Invalid login and / or password"}]);
            }
            else if (user.first().isBan == true) {
                beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Your account as been banished"}]);
            } else {
                setLoggedUser(user.first());
                beluga.triggerDispatcher.dispatch("beluga_account_login_success", [
                    user.first()
                ]);
            }
        }
		triggers.afterLogin.dispatch();
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
            user.isAdmin = false;
            user.isBan = false;
            user.insert();
			//TODO AB Send activation mail
            triggers.subscribeSuccess.dispatch({user: user});
        } else {
            triggers.subscribeFail.dispatch({error : error});
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

    public function getUsers() : Array<User> {
        var user = this.getLoggedUser();
        var list = new Array<User>();

        if (user == null) {
            return list;
        }
        for (tmp in User.manager.dynamicSearch({})) {
            if (tmp.id != user.id) {
                list.push(tmp);
            }
        }
        return list;
    }

    public function activateUser(userId : SId) {
        var user = User.manager.get(userId);

        if (user != null) {
            user.emailVerified = true;
            user.update();
        }
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

    public function _showUser(args: { id: Int}): Void {
        Beluga.getInstance().getModuleInstance(Account).showUser(args);
    }

    public function showUser(args: { id: Int}): Void {
        beluga.triggerDispatcher.dispatch("beluga_account_show_user", [args]);
    }

    public static function _deleteUser(args : {id: Int}) : Void {
        Beluga.getInstance().getModuleInstance(Account).deleteUser(args);
    }

    public function deleteUser(args : {id: Int}) : Void {
        var user = this.getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "You have to be logged"}]);
        } else if (user.id != args.id && user.isAdmin == false) {
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "You can't delete this account"}]);
        } else {
            for (tmp in User.manager.dynamicSearch({id : args.id })) {
                tmp.delete();
                Session.remove(SESSION_USER);
                beluga.triggerDispatcher.dispatch("beluga_account_delete_success", []);
                return;
            }
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "Unknown user"}]);
        }
    }

    public function edit(user_id: Int, email : String) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
        } else {
            if (user.id != user_id && user.isAdmin == false) {
                beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
            } else {
                user.email = email;
                user.update();
                beluga.triggerDispatcher.dispatch("beluga_account_edit_success", []);
            }
        }
    }
}
