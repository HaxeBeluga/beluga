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

class NotificationTest {
    public var beluga(default, null) : Beluga;
    public var notif(default, null) : Notification;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.notif = beluga.getModuleInstance(Notification);
        this.notif.triggers.defaultNotification.add(this.doDefault);
        this.notif.triggers.createFail.add(this.doDefault);
        //this.notif.triggers.createSuccess.add(this.doCreateSuccess);
        this.notif.triggers.deleteFail.add(this.doDefault);
        this.notif.triggers.deleteSuccess.add(this.doDefault);
        this.notif.triggers.print.add(this.doPrint);
    }

    public function doDefault() {
        var widget = notif.getWidget("notification");

        widget.context = notif.getDefaultContext();
        var html = Renderer.renderDefault("page_notification", "Notifications list", {
            notificationWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doPrint(args : {notif_id : Int}) {
        if (notif.canPrint(args.notif_id)) {
            var widget = notif.getWidget("print_notif");

            widget.context = notif.getPrintContext(args.notif_id);
            var html = Renderer.renderDefault("page_notification", "Notification", {
                notificationWidget: widget.render()
            });
            Sys.print(html);
        } else {
            doDefault();
        }
    }
}