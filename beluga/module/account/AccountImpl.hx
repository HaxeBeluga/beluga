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
import beluga.core.validation.AttrValidator;
import beluga.core.validation.SimpleValidator;
import beluga.core.validation.Validator;
import beluga.core.form.DataChecker;

class AccountImpl extends ModuleImpl implements AccountInternal implements MetadataReader {

    private static inline var SESSION_USER = "session_user";
	
	public var triggers = new AccountTrigger();
	public var widgets : AccountWidget;
	
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
		if (loginValidation(args)) {
			//Execute Action
			var user : List<User> = User.manager.dynamicSearch({
				login : args.login,
				hashPassword: haxe.crypto.Md5.encode(args.password)
			});

			if (user.length > 1) {
				//Somethings wrong in database
				widgets.loginForm.globalErrorKey = "loginForm.error.internalError";
				triggers.loginInternalError.dispatch();
			} else if (user.length == 0) {
				widgets.loginForm.globalErrorKey = "loginForm.error.wrongPassword";
				triggers.loginWrongPassword.dispatch();
			} else {
				loggedUser = user.first();
				widgets.loginForm.globalSuccessKey = "loginForm.success";
				triggers.loginSuccess.dispatch();
			}
		}
		triggers.afterLogin.dispatch();
    }

	public function loginValidation(args : {
        login : String,
        password : String
    }) {
		//Form validation
		var validatorForm = new SimpleValidator();
		
		var pwdValidator = new AttrValidator(validatorForm, args.password, [
			"pwd.sizeBetween" => DataChecker.checkRangeLength.bind(_ , 2, 255),
			"pwd.notNullOrEmpty" => DataChecker.isNotBlanckOrNull
		]);
		
		var loginValidator = new AttrValidator(validatorForm, args.login, [
			"login.sizeBetween" => DataChecker.checkRangeLength.bind(_, 2, 255),
			"login.notNullOrEmpty" => DataChecker.isNotBlanckOrNull
		]);	
		
		var errorList = validatorForm.validate();
		
		//Update widget
		if (errorList.length != 0) {
			widgets.loginForm.loginErrorKeys = loginValidator.validate();
			widgets.loginForm.passwordErrorKeys = pwdValidator.validate();
			triggers.loginValidationError.dispatch();
			return false;
		}
		return true;
	}
	
    public function subscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
        var error = "";
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
