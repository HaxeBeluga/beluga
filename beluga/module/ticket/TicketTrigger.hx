// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class TicketTrigger {
    public var show = new TriggerVoid();
    public var create = new TriggerVoid();
    public var browse = new TriggerVoid();
    public var admin = new TriggerVoid();
    public var deleteLabelFail = new TriggerVoid();
    public var deleteLabelSuccess = new TriggerVoid();
    public var addLabelFail = new TriggerVoid();
    public var addLabelSuccess = new TriggerVoid();
    public var assignNotify = new Trigger<{title: String, text: String, user_id: SId}>();

    public function new() {}
}