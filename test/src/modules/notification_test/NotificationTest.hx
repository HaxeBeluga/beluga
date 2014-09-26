// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.notification_test;

import haxe.web.Dispatch;
import haxe.Resource;

import main_view.Renderer;

import beluga.core.Beluga;
import beluga.core.Widget;

import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.notification.Notification;
import beluga.module.notification.NotificationErrorKind;
import beluga.module.notification.model.NotificationModel;

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
        this.notif.triggers.createFail.add(this.createFail);
        //this.notif.triggers.createSuccess.add(this.doCreateSuccess);
        this.notif.triggers.deleteFail.add(this.deleteFail);
        this.notif.triggers.deleteSuccess.add(this.doDefault);
        this.notif.triggers.print.add(this.doPrint);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_notification", "Notifications list", {
            notificationWidget: notif.widgets.notification.render()
        });
        Sys.print(html);
    }

    public function doPrint() {
        var html = Renderer.renderDefault("page_notification", "Notifications list", {
            notificationWidget: notif.widgets.print.render()
        });
        Sys.print(html);
    }

    public function createFail(args : {error : NotificationErrorKind}) {
        this.doDefault();
    }

    public function deleteFail(args : {error : NotificationErrorKind}) {
        this.doDefault();
    }
}