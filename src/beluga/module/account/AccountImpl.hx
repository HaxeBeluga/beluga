package beluga.module.account;
import beluga.core.module.ModuleImpl;
import haxe.xml.Fast;

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
	
	@:option(password)
	@:return(true)
	public static function checkPassword(password : String) : Bool {
		return false;
	}
}