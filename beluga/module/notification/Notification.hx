// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.notification;

import beluga.core.module.Module;

import beluga.module.notification.model.NotificationModel;
import beluga.module.notification.NotificationWidget;

interface Notification extends Module {
    public var triggers: NotificationTrigger;
    public var widgets : NotificationWidget;

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