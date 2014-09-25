// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.mail;

import haxe.xml.Fast;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.core.BelugaI18n;

import beluga.module.account.Account;
import beluga.module.mail.model.MailModel;
import beluga.module.mail.MailErrorKind;
import beluga.module.mail.MailWidget;

class MailImpl extends ModuleImpl implements MailInternal {
    public var triggers = new MailTrigger();

    // Context variables
    public var error_msg : String;
    public var success_msg : String;
    public var receiver : String;
    public var subject : String;
    public var message : String;

    private var actual_mail_id : Int;

    public var widgets: MailWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/module/mail/locale/");

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new MailWidget();
    }

    public function createDefaultContext() : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null && error_msg == "") {
            error_msg = "missing_login";
        }
    }

    public function setActualMail(mail_id : Int) : Void {
        this.actual_mail_id = mail_id;
    }

    public function getActualMail() : MailModel {
        return this.getMail(this.actual_mail_id);
    }

    public function canPrint(mail_id: Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "missing_login";
            return false;
        }
        if (this.getMail(mail_id) == null) {
            return false;
        }
        return true;
    }

    public function getMail(id : Int) : MailModel {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in MailModel.manager.dynamicSearch( {user_id : user.id, id : id} )) {
                return tmp;
            }
            error_msg = "id_not_found";
        } else {
            error_msg = "missing_login";
        }
        return null;
    }

    public function getDraftMails() : Array<MailModel> {
        var ret = new Array<MailModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in MailModel.manager.dynamicSearch( {user_id : user.id, hasBeenSent : false} ))
                ret.push(tmp);
        }
        return ret;
    }

    public function getSentMails() : Array<MailModel> {
        var ret = new Array<MailModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in MailModel.manager.dynamicSearch( {user_id : user.id, hasBeenSent : true} ))
                ret.push(tmp);
        }
        return ret;
    }

    public function sendMail(args : {receiver : String, subject : String, message : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        receiver = args.receiver;
        subject = args.subject;
        message = args.message;
        if (user == null) {
            error_msg = "missing_login";
            this.triggers.sendFail.dispatch({error : MissingLogin});
            return;
        }
        if (args.receiver == "") {
            error_msg = "missing_receiver";
            this.triggers.sendFail.dispatch({error : MissingReceiver});
            return;
        }
        if (args.subject == "") {
            error_msg = "missing_subject";
            this.triggers.sendFail.dispatch({error : MissingSubject});
            return;
        }
        if (args.message == "") {
            error_msg = "missing_message";
            this.triggers.sendFail.dispatch({error : MissingMessage});
            return;
        }
        #if php
        if (!php.Lib.mail(args.receiver, args.subject, args.message, "From: " + user.email + "\r\n")) {
            error_msg = "mail_not_sent";
            this.triggers.sendFail.dispatch({error : MailNotSent});
            return;
        }
        #else
        error_msg = "not_supported";
        this.triggers.sendFail.dispatch({error : OnlyPHP});
        return;
        #end
        this.triggers.sendSuccess.dispatch();
    }
}