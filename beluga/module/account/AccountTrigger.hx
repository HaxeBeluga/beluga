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
	public var loginInternalError : TriggerVoid;
	public var loginWrongPassword : TriggerVoid;
	public var loginSuccess : TriggerVoid;
	public var afterLogin : TriggerVoid;
	
	//Logout
	public var afterLogout: TriggerVoid;

	//subscribe
	public var subscribeFail: Trigger<{error : String}>;
	public var subscribeSuccess: Trigger<{user : User}>;
	public var afterSubscribe: TriggerVoid;
	
	public function new()
	{
		
	}
	
}