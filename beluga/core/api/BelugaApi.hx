package beluga.core.api;

import haxe.web.Dispatch;
import beluga.core.macro.ModuleLoader;

class BelugaApi implements IAPI
{
	private var beluga : Beluga;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
	}

	//Handle url like www.beluga.fr?trigger=login
	public function doDefault(d : Dispatch) {
		Sys.print("Welcome !");
	}
	
	/*
	 * Modules API are generated like:
		 * public function doModule(d : Dispatch) {
			* d.dispatch(new ModuleAPI(beluga));
		 * }
	 */
}