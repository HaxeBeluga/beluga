package beluga.module.notification;

import beluga.core.module.Module;

import beluga.module.notification.model.NotificationModel;

interface Notification extends Module {
    public var triggers: NotificationTrigger;

    public function getDefaultContext() : Dynamic;
    public function getPrintContext(notif_id: Int) : Dynamic;

    public function print(args : {id : Int}) : Void;
    public function create(args : {
        title : String,
        text : String,
        user_id : Int
    }) : Void;
    public function delete(args : {
        id : Int}) : Void;
    public function getNotifications() : Array<NotificationModel>;
    public function getNotification(notif_id: Int, user_id: Int) : NotificationModel;
    public function canPrint(notif_id: Int) : Bool;
}