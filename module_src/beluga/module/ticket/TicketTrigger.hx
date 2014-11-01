// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket;

import beluga.trigger.Trigger;
import beluga.trigger.TriggerVoid;

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