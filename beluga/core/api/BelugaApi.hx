package beluga.core.api;

import haxe.web.Dispatch;
import beluga.core.macro.ModuleLoader;
import haxe.Session;

class BelugaApi implements IAPI
{
	public var beluga : Beluga;
	
	private function handleSessionPath()
	{

	}

	public function new() {
	}

	//Handle url like www.beluga.fr?trigger=login
	public function doDefault(d : Dispatch) {
		Sys.print("Welcome !");
	}
	
	/*
	 * Modules API are generated like:
		 * public function doModule(d : Dispatch) {
			* d.dispatch(new ModuleApi(beluga));
		 * }
	 */
}