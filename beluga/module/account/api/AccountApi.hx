package beluga.module.account.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.core.form.Object;

class AccountApi  {
    public var beluga : Beluga;
    public var module : Account;

    public function new() {
    }

    public function doLogin(args : {
        login : String,
        password : String,
    }) {
		module.login(args);
    }

    public function doLogout() {
		module.logout();
    }

    public function doShowUser(args: { id: Int }) {
        this.module.showUser(args);
    }

    public function doSubscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
       module.subscribe(args);
    }

    public function doDefault() {
        this.module.triggers.defaultPage.dispatch();
    }

    public function doEdit(args : {?email : String}) {
        if (args.email != null) {
			module.edit(module.loggedUser.id, args.email);
		}
    }

}
