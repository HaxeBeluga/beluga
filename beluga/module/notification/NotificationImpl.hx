package beluga.module.notification;

import haxe.xml.Fast;

import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.module.notification.model.NotificationModel;

class NotificationImpl extends ModuleImpl implements NotificationInternal {
    public var triggers = new NotificationTrigger();

    public function new() {
        super();
    }

	override public function initialize(beluga : Beluga) : Void {

	}

    public function getNotifications() : Array<NotificationModel> {
        var ret = new Array<NotificationModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

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
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.print.dispatch({notif: null});
            return;
        }

        for (tmp in NotificationModel.manager.dynamicSearch( {user_id : user.id, id : args.id} )) {
            tmp.hasBeenRead = true;
            tmp.update();
            this.triggers.print.dispatch({notif: tmp});
            return;
        }
    }

    public function delete(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.deleteFail.dispatch();
            return;
        }
        for (tmp in NotificationModel.manager.dynamicSearch( {id : args.id, user_id : user.id} )) {
            tmp.delete();
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        this.triggers.deleteFail.dispatch();
    }

    public function create(args : {title : String, text : String, user_id: Int}) {
        if (args.title == "" || args.text == "") {
            this.triggers.createFail.dispatch();
            return;
        }
        var notif = new NotificationModel();

        notif.title = args.title;
        notif.text = args.text;
        notif.user_id = args.user_id;
        notif.hasBeenRead = false;
        notif.creationDate = Date.now();
        notif.insert();
        this.triggers.createSuccess.dispatch();
    }
}