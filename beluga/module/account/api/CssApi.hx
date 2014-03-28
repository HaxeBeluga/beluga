package beluga.module.account.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.account.Account;

/**
 * ...
 * @author brissa_A
 */
class CssApi
{

	public function new() 
	{
		
	}

	public function doLogin() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(Account).getWidget("login").getCss());
	}

}