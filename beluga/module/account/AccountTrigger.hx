package beluga.module.account;

import beluga.core.trigger.Trigger;

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

	public function new() 
	{
		
	}
	
}