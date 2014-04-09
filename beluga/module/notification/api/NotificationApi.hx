package beluga.module.notification.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.notification.Notification;
import haxe.web.Dispatch;
import php.Web;

class NotificationApi
{
	var beluga : Beluga;
	var notif : Notification;

	public function new(beluga : Beluga, notif : Notification) {
		this.beluga = beluga;
		this.notif = notif;
	}

	public function doDefault() {
		beluga.triggerDispatcher.dispatch("beluga_notif_default", []);
	}

	public function doPrint(args : {id : Int}) {
		notif.print(args);
	}

	public function doCreate(args : {title : String, text : String, user_id: Int}) {
		notif.create(args);
	}

	public function doDelete(args : {id : Int}) {
		notif.delete(args);
	}
}
