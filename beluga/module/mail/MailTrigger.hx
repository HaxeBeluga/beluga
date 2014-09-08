package beluga.module.mail;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class MailTrigger {
    public var sendFail = new TriggerVoid();
    public var sendSuccess = new TriggerVoid();
    public var print = new Trigger<{id : Int}>();
    public var defaultMail = new TriggerVoid();
    public var create = new TriggerVoid();

    public function new() {}
}