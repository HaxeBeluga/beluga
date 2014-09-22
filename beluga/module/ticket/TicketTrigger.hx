package beluga.module.ticket;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import beluga.module.ticket.TicketErrorKind;

import sys.db.Types;

class TicketTrigger {
    public var show = new TriggerVoid();
    public var create = new TriggerVoid();
    public var browse = new TriggerVoid();
    public var admin = new TriggerVoid();
    public var deleteLabelFail = new Trigger<{error: TicketErrorKind}>();
    public var deleteLabelSuccess = new TriggerVoid();
    public var addLabelFail = new Trigger<{error: TicketErrorKind}>();
    public var addLabelSuccess = new TriggerVoid();
    public var submitFail = new Trigger<{error: TicketErrorKind}>();
    public var submitSuccess = new Trigger<{id: Int}>();
    public var commentFail = new Trigger<{error: TicketErrorKind}>();
    public var commentSuccess = new Trigger<{id: Int}>();
    public var assignNotify = new Trigger<{title: String, text: String, user_id: SId}>();

    public function new() {}
}