package beluga.module.account;
import beluga.core.module.ModuleImpl;
import haxe.xml.Fast;
import beluga.module.account.api.AccountApi;

/**
 * ...
 * @author Masadow
 */
class AccountImpl extends ModuleImpl implements AccountInternal
{

	public function new() 
	{
		super();
	}

	override public function loadConfig(data : Fast) {
		
	}
	
	
	/** Actions trigger **/
	public static function login() {
//		beluga.view();
	}
	
	public static function subscribe() {
		
	}
	
	/** ENDOF Actions trigger **/
	
	@:option(password)
	@:return(true)
	public static function checkPassword(password : String) : Bool {
		return false;
	}

	public function isLogged() : Bool {
		return false;
	}

}
