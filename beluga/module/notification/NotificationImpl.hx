package beluga.module.notification;

import beluga.module.account.Account;
import beluga.core.module.ModuleImpl;
import beluga.module.notification.model.NotificationModel;
import beluga.core.Beluga;

import haxe.xml.Fast;

class NotificationImpl extends ModuleImpl implements NotificationInternal {

	public function new() {
		super();
	}
	
	override public function loadConfig(data : Fast) {
	}

	public function getNotifications() : Array<NotificationModel> {
		var ret = new Array<NotificationModel>();
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in NotificationModel.manager.dynamicSearch( {user_id : user.id} ))
				ret.push(tmp);
		}
		return ret;
	}

	public static function _print(args : {id : Int}) {
		Beluga.getInstance().getModuleInstance(Notification).print(args);
	}

	public function print(args : {id : Int}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null) {
			beluga.triggerDispatcher.dispatch("beluga_notif_printx", [{notif : null}]);
			return;
		}

		for (tmp in NotificationModel.manager.dynamicSearch( {user_id : user.id, id : args.id} )) {
			tmp.hasBeenRead = true;
			tmp.update();
			beluga.triggerDispatcher.dispatch("beluga_notif_printx", [{notif : tmp}]);
			return;
		}
	}

	@bTrigger("beluga_notification_delete")
	public static function _delete(args : {id : Int}) {
		Beluga.getInstance().getModuleInstance(Notification).delete(args);
	}

	public function delete(args : {id : Int}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null) {
			beluga.triggerDispatcher.dispatch("beluga_notif_delete_fail", []);
			return;
		}
		for (tmp in NotificationModel.manager.dynamicSearch( {id : args.id, user_id : user.id} )) {
			tmp.delete();
			beluga.triggerDispatcher.dispatch("beluga_notif_delete_success", []);
			return;
		}
		beluga.triggerDispatcher.dispatch("beluga_notif_delete_fail", []);
	}

	@bTrigger("beluga_notification_create")
	public static function _create(args : {title : String, text : String, user_id: Int}) {
		Beluga.getInstance().getModuleInstance(Notification).create(args);
	}

	public function create(args : {title : String, text : String, user_id: Int}) {
		if (args.title == "" || args.text == "") {
			beluga.triggerDispatcher.dispatch("beluga_notif_create_fail", []);
			return;
		}
		var notif = new NotificationModel();

		notif.title = args.title;
		notif.text = args.text;
		notif.user_id = args.user_id;
		notif.hasBeenRead = false;
		notif.creationDate = Date.now();
		notif.insert();
		beluga.triggerDispatcher.dispatch("beluga_notif_create_success", []);
	}
}