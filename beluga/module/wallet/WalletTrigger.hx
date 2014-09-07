package beluga.module.wallet;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class WalletTrigger {
    public var creationSuccess = new TriggerVoid();
    public var creationFail = new TriggerVoid();
    public var currencyCreationSuccess = new TriggerVoid();
    public var currencyCreationFail = new TriggerVoid();
    public var currencyRemoveSuccess = new TriggerVoid();
    public var currencyRemoveFail = new TriggerVoid();
    public var setSiteCurrencySuccess = new TriggerVoid();
    public var setSiteCurrencyFail = new TriggerVoid();

    public function new() {}
}