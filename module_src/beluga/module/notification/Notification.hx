// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.notification;

import beluga.module.notification.api.NotificationApi;
import haxe.xml.Fast;

import beluga.module.Module;
import beluga.Beluga;
import beluga.I18n;

import beluga.module.account.Account;
import beluga.module.notification.model.NotificationModel;
import beluga.module.notification.NotificationErrorKind;

class Notification extends Module {
    public var triggers = new NotificationTrigger();
    public var widgets: NotificationWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/notification/locale/");

    // Interval variables for contexts
    public var error_id : NotificationErrorKind;
    public var success_msg : String;
    public var actual_notif_id : Int;

    public function new() {
        super();
        error_id = None;
        actual_notif_id = -1;
        success_msg = "";
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new NotificationWidget();
        beluga.api.register("notification", new NotificationApi(beluga, this));        
    }

    public function setActualNotificationId(notif_id : Int) : Void {
        this.actual_notif_id = notif_id;
    }

    public function canPrint(notif_id: Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            return false;
        }
        var notif = getNotification(notif_id, user.id);
        if (notif == null) {
            error_id = IdNotFound;
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

    // Returns all notifications for logged user
    public function getNotifications() : Array<NotificationModel> {
        var ret = new Array<NotificationModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in NotificationModel.manager.dynamicSearch({user_id : user.id}))
                ret.push(tmp);
        }
        return ret;
    }

    public function print(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        // Will be considered as an Error
        this.actual_notif_id = -1;
        if (user != null) {
            for (tmp in NotificationModel.manager.dynamicSearch( {user_id : user.id, id : args.id} )) {
                this.actual_notif_id = args.id;
                tmp.hasBeenRead = true;
                tmp.update();
                this.triggers.print.dispatch();
                return;
            }
        }
    }

    public function delete(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.deleteFail.dispatch({error : error_id});
            return;
        }
        for (tmp in NotificationModel.manager.dynamicSearch( {id : args.id, user_id : user.id} )) {
            tmp.delete();
            success_msg = "delete_success";
            this.triggers.deleteSuccess.dispatch();
            return;
        }
        error_id = IdNotFound;
        this.triggers.deleteFail.dispatch({error : error_id});
    }

    public function create(args : {title : String, text : String, user_id: Int}) {
        if (args.title == "") {
            error_id = MissingTitle;
            this.triggers.createFail.dispatch({error : error_id});
            return;
        }
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.createFail.dispatch({error : error_id});
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

    public function getErrorString(error: NotificationErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case MissingMessage: BelugaI18n.getKey(this.i18n, "missing_message");
            case MissingTitle: BelugaI18n.getKey(this.i18n, "missing_title");
            case IdNotFound: BelugaI18n.getKey(this.i18n, "id_not_found");
            case None: null;
        };
    }
}