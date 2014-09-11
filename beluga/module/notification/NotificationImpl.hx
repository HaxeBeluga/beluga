package beluga.module.notification;

import haxe.xml.Fast;

import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

import beluga.module.account.Account;
import beluga.module.notification.model.NotificationModel;

class NotificationImpl extends ModuleImpl implements NotificationInternal {
    public var triggers = new NotificationTrigger();

    // Interval variables for contexts
    private var error_msg : String;
    private var success_msg : String;

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
    }

	override public function initialize(beluga : Beluga) : Void {

	}

    public function getDefaultContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "Please log in !";
        }
        return {notifs : getNotifications(), user : user, error : error_msg, success : success_msg,
            path : "/beluga/notification/"};
    }

    public function getPrintContext(notif_id: Int) : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        return {notif : getNotification(notif_id, user.id), path : "/beluga/notification/"}
    }

    public function canPrint(notif_id: Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            return false;
        }
        var notif = getNotification(notif_id, user.id);
        if (notif == null) {
            error_msg = "Notification hasn't been found...";
            return false;
        }
        return true;
    }

    public function getNotification(notif_id: Int, user_id: Int) : NotificationModel {
        for (notif in NotificationModel.manager.dynamicSearch( {id : notif_id, user_id : user_id} )) {
            return notif;
        }
        return null;
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

    public function print(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.print.dispatch({notif_id: -1});
            return;
        }

        for (tmp in NotificationModel.manager.dynamicSearch( {user_id : user.id, id : args.id} )) {
            tmp.hasBeenRead = true;
            tmp.update();
            this.triggers.print.dispatch({notif_id: tmp.id});
            return;
        }
    }

    public function delete(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "You have to be logged !";
            this.triggers.deleteFail.dispatch();
            return;
        }
        for (tmp in NotificationModel.manager.dynamicSearch( {id : args.id, user_id : user.id} )) {
            tmp.delete();
            success_msg = "Notification has been successfully deleted !";
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        error_msg = "Unknown notification id";
        this.triggers.deleteFail.dispatch();
    }

    public function create(args : {title : String, text : String, user_id: Int}) {
        if (args.title == "") {
            error_msg = "Error : missing title";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.text == "") {
            error_msg = "Error : missing text";
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