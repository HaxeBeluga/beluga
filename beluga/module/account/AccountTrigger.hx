package beluga.module.account;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;
import beluga.module.account.model.User;

/**
 * ...
 * @author brissa_A
 */
class AccountTrigger
{
	//Login
	public var loginInternalError = new TriggerVoid();
	public var loginWrongPassword = new TriggerVoid();
	public var loginSuccess = new TriggerVoid();
	public var afterLogin = new TriggerVoid();
	
	//Logout
	public var afterLogout = new TriggerVoid();

	//subscribe
	public var subscribeFail = new Trigger<{error : String}>();
	public var subscribeSuccess = new Trigger<{user : User}>();
	public var afterSubscribe = new TriggerVoid();
	
	public function new()
	{
		
	}
	
}