package beluga.module.market;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class MarketTrigger {
    public var addProductSuccess = new TriggerVoid();
    public var addProductFail = new TriggerVoid();
    public var removeProductSuccess = new TriggerVoid();
    public var removeProductFail = new TriggerVoid();
    public var checkoutCartSuccess = new TriggerVoid();
    public var checkoutCartFail = new TriggerVoid();

    public function new() {}
}