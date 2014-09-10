package beluga.module.notification.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

import beluga.module.notification.Notification;

class NotificationApi {
    public var beluga : Beluga;
    public var module : Notification;

    public function new() { }

    public function doDefault() {
        module.triggers.defaultNotification.dispatch();
    }

	#if (php || neko)
    public function doPrint(args : {id : Int}) {
        module.print(args);
    }
	#end

    public function doCreate(args : {title : String, text : String, user_id: Int}) {
        module.create(args);
    }

	#if (php || neko)
    public function doDelete(args : {id : Int}) {
        module.delete(args);
    }
	#end
}
