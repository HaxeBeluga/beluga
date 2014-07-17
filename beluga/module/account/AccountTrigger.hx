package beluga.module.account;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

/**
 * ...
 * @author brissa_A
 */
class AccountTrigger
{
	public var login = new Trigger<{
        login : String,
        password : String,
    }>();
	
	public var logout = new TriggerVoid();

	public function new()
	{
		
	}
	
}