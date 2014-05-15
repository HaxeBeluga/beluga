package beluga.module.account.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import haxe.web.Dispatch;

class AccountApi 
{
	var beluga : Beluga;
	var account : Account;

	public function new(beluga : Beluga, account : Account) {
		this.beluga = beluga;
		this.account = account;
	}

	//
	//Login
	//
	public function doLogin(args : {
		login : String,
		password : String,
	}) {
		beluga.triggerDispatcher.dispatch("beluga_account_login", [args]);
	}

	public function doLogout() {
		this.account.logout();
	}

	public function doPrintInfo() {
		beluga.triggerDispatcher.dispatch("beluga_account_printInfo", []);
	}

	public function doShowUser(args: { id: Int }) {
		beluga.triggerDispatcher.dispatch("beluga_account_show_user", [args]);
	}

	//
	//Subscription
	//
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
