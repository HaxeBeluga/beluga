// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.mail;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

import beluga.module.mail.MailErrorKind;

class MailTrigger {
    public var sendFail = new Trigger<{error : MailErrorKind}>();
    public var sendSuccess = new TriggerVoid();
    public var print = new TriggerVoid();
    public var defaultMail = new TriggerVoid();
    public var create = new TriggerVoid();

    public function new() {}
}