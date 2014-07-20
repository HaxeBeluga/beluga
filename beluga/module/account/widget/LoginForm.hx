package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.WidgetVoid;
import haxe.Template;
import haxe.Resource;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;

/**
 * ...
 * @author brissa_A
 */
class LoginForm implements WidgetVoid
{

	private static var id = 0;
	private var templateFileContent : String;
	private var template : Template;
	
	public function new() 
	{
		templateFileContent = Resource.getString("beluga_account_login.mtt");
		template = new haxe.Template(templateFileContent);
	}

	public function render() : String {
		var context = { 		
			isLogged : Beluga.getInstance().getModuleInstance(Account).isLogged,
			loggedUser : Beluga.getInstance().getModuleInstance(Account).loggedUser,
			base_url : ConfigLoader.getBaseUrl(),
			id: id++
		};
        return template.execute(context);
	}
	
}