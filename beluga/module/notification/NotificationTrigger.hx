// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.notification;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;
import beluga.module.notification.model.NotificationModel;
import beluga.module.notification.NotificationErrorKind;

import sys.db.Types;

class NotificationTrigger {
    public var defaultNotification = new TriggerVoid();
    public var createSuccess = new TriggerVoid();
    public var createFail = new Trigger<{error : NotificationErrorKind}>();
    public var deleteSuccess = new TriggerVoid();
    public var deleteFail = new Trigger<{error : NotificationErrorKind}>();
    public var print = new TriggerVoid();

    public function new() {}
}