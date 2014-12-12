package beluga.module.paypal;

import beluga.trigger.TriggerVoid;

class PaypalTrigger
{

    public var paymentApproved = new TriggerVoid(custom : String);
    public var paymentNotApproved = new TriggerVoid();

    public var paymentExecuted = new TriggerVoid(custom : String);
    public var paymentNotExecuted = new TriggerVoid();
    
    public var connectionFail = new TriggerVoid();

    public function new() 
    {
        
    }
    
}