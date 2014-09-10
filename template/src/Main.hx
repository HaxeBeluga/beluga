package ;

import beluga.core.Beluga;
import haxe.web.Dispatch;
import php.Web;
import beluga.module.account.Account;

/**
 * ...
 * @author Masadow
 */
class Main
{
	public static var beluga : Beluga;
	
    static function main() {
        var beluga = Beluga.getInstance();
        Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);
        Sys.print(beluga.getModuleInstance(Account).widgets.loginForm.render());
        beluga.cleanup();
    }
}