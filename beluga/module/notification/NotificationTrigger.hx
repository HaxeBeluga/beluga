package beluga.module.notification;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;
import beluga.module.notification.model.NotificationModel;

import sys.db.Types;

class NotificationTrigger {
    public var defaultNotification = new TriggerVoid();
    public var createSuccess = new TriggerVoid();
    public var createFail = new TriggerVoid();
    public var deleteSuccess = new TriggerVoid();
    public var deleteFail = new TriggerVoid();
    public var print = new Trigger<{notif_id: Int}>();

    public function new() {}
}