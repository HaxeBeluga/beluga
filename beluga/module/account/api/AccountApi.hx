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

	//
	//Subscription
	//
	public function doSubscribe(args : {
		login : String,
		password : String,
		password_conf : String
	}) {
		beluga.triggerDispatcher.dispatch("beluga_account_subscribe", [args]);
	}

	public function doDefault() {
        trace("Account default page");
	}
	
	public function doCss(d : Dispatch) {
		d.dispatch(new CssApi() );
	}

}
