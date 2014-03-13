package beluga.core.api;

import haxe.web.Dispatch;
import beluga.module.account.Account;
import beluga.module.account.api.AccountApi;

class BelugaApi implements IAPI
{
	private var beluga : Beluga;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
	}

	//Handle url like www.beluga.fr?trigger=login
	public function doDefault(d : Dispatch) {
		Sys.print("Vous etes sur la page d'accueil !");
	}

	public function doAccount(d : Dispatch) {
		d.dispatch(new AccountApi(beluga));
	}
	
	/*
	 * Modules API are generated like:
		 * public function doModule(d : Dispatch) {
			* d.dispatch(new ModuleApi(beluga));
		 * }
	 */

}