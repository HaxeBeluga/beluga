package beluga.core.api;

import haxe.web.Dispatch;
import haxe.Session;

import beluga.core.macro.ModuleLoader;

class BelugaApi implements IAPI<String> {
    public var beluga : Beluga;
    public var module : String;

    private function handleSessionPath() {}

    public function new() {}

    //Handle url like www.beluga.fr?trigger=login
    public function doDefault(d : Dispatch) {
        Sys.print("Welcome !");
    }
	
	public function doBeluga(d : Dispatch) {
		d.dispatch(this);
	}

    /*
     * Modules API are generated like:
         * public function doModule(d : Dispatch) {
            * d.dispatch(new ModuleApi(beluga));
         * }
     */
}