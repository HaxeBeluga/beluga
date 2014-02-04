package beluga.core;

import haxe.web.Dispatch;
import beluga.module.account.Account;
import beluga.module.account.api.AccountApi;

class BelugaApi
{
	private var beluga : Beluga;
	private var acc : Account;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
		this.acc = beluga.getModuleInstance(Account);
	}

	public function doDefault() {
		Sys.print("Vous etes sur la page d'accueil !");
	}

	//Handle url like www.beluga.fr/account/login
	public function doAccount(d : Dispatch) {
		d.dispatch(new AccountApi(beluga, acc));
	}

}