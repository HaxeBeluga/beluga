package modules.notification_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.notification.Notification;
import beluga.module.notification.model.NotificationModel;
import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

/**
 * Beluga #1
 * @author Guillaume Gomez
 */

class NotificationTest implements MetadataReader
{
    public var beluga(default, null) : Beluga;
    public var notif(default, null) : Notification;
    private var error_msg : String;
    private var success_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.notif = beluga.getModuleInstance(Notification);
        this.notif.triggers.defaultNotification.add(this.doDefault);
        this.notif.triggers.createFail.add(this.doCreateFail);
        this.notif.triggers.createSuccess.add(this.doCreateSuccess);
        this.notif.triggers.deleteFail.add(this.doDeleteFail);
        this.notif.triggers.deleteSuccess.add(this.doDeleteSuccess);
        this.notif.triggers.print.add(this.doPrint);
        this.error_msg = "";
        this.success_msg = "";
    }

    public function doDefault() {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            Web.setHeader("Content-Type", "text/plain");
            Sys.println("Please log in !");
            return;
        }
        var widget = notif.getWidget("notification");
        widget.context = {notifs : notif.getNotifications(), user : user, error : error_msg, success : success_msg, path : "/beluga/notification/"};

        var notifWidget = widget.render();

        var html = Renderer.renderDefault("page_notification", "Notifications list", {
            notificationWidget: notifWidget
        });
        Sys.print(html);
    }

    public function doPrint(args : {notif : NotificationModel}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            doDefault();
            return;
        }
        if (args.notif == null) {
            error_msg = "Notification hasn't been found...";
            doDefault();
            return;
        }
        var widget = notif.getWidget("print_notif");
        widget.context = {notif : args.notif, path : "/beluga/notification/"};

        var notifWidget = widget.render();

        var html = Renderer.renderDefault("page_notification", "Notification", {
            notificationWidget: notifWidget
        });
        Sys.print(html);
    }

    public function doCreateFail() {
        error_msg = "Error ! Notification has not been created...";
        this.doDefault();
    }

    public function doCreateSuccess() {
        // success_msg = "Notification has been successfully created !";
        // this.doDefault();
    }

    public function doDeleteSuccess() {
        success_msg = "Notification has been successfully deleted !";
        this.doDefault();
    }

    public function doDeleteFail() {
        error_msg = "Error when trying to delete notification...";
        this.doDefault();
    }
}