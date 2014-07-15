package beluga.module.account.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;

class AccountApi  {
    public var beluga : Beluga;
    public var module : Account;

    public function new() {
    }

    public function doLogin(args : {
        login : String,
        password : String,
    }) {
		beluga.getModuleInstance(Account).trigger.login.dispatch(args);
    }

    public function doLogout() {
        module.logout();
    }

    public function doPrintInfo() {
        beluga.triggerDispatcher.dispatch("beluga_account_printInfo", []);
    }

    public function doShowUser(args: { id: Int }) {
        beluga.triggerDispatcher.dispatch("beluga_account_show_user", [args]);
    }

    public function doSubscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
        beluga.triggerDispatcher.dispatch("beluga_account_subscribe", [args]);
    }

    public function doDefault() {
        trace("Account default page");
    }

    public function doEdit() {
        beluga.triggerDispatcher.dispatch("beluga_account_edit", []);
    }

    public function doSave(args : {email : String}) {
        beluga.triggerDispatcher.dispatch("beluga_account_save", [args]);
    }

}
