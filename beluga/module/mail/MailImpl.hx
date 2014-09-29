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
    public var error_id : MailErrorKind;
    public var success_msg : String;
    public var receiver : String;
    public var subject : String;
    public var message : String;

    private var actual_mail_id : Int;

    public var widgets: MailWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/module/mail/locale/");

    public function new() {
        super();
        error_id = None;
        success_msg = "";
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new MailWidget();
    }

    public function createDefaultContext() : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null && error_id == None) {
            error_id = MissingLogin;
        }
    }

    public function setActualMail(mail_id : Int) : Void {
        this.actual_mail_id = mail_id;
    }

    public function getActualMail() : MailModel {
        return this.getMail(this.actual_mail_id);
    }

    public function canPrint() : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            return false;
        }
        if (this.getActualMail() == null) {
            return false;
        }
        return true;
    }

    public function getMail(id : Int) : MailModel {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (mail in MailModel.manager.dynamicSearch( {user_id : user.id, id : id} )) {
                return mail;
            }
            error_id = UnknownId;
        } else {
            error_id= MissingLogin;
        }
        return null;
    }

    public function getDraftMails() : Array<MailModel> {
        var draft_mails = new Array<MailModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (draft_mail in MailModel.manager.dynamicSearch( {user_id : user.id, hasBeenSent : 0} ))
                draft_mails.push(draft_mail);
        }
        return draft_mails;
    }

    public function getSentMails() : Array<MailModel> {
        var sent_mails = new Array<MailModel>();
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (sent_mail in MailModel.manager.dynamicSearch( {user_id : user.id, hasBeenSent : 1} ))
                sent_mails.push(sent_mail);
        }
        return sent_mails;
    }

    public function sendMail(args : {receiver : String, subject : String, message : String}) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        receiver = args.receiver;
        subject = args.subject;
        message = args.message;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.sendFail.dispatch({error : MissingLogin});
            return;
        }
        if (args.receiver == "") {
            error_id = MissingReceiver;
            this.triggers.sendFail.dispatch({error : MissingReceiver});
            return;
        }
        if (args.subject == "") {
            error_id = MissingSubject;
            this.triggers.sendFail.dispatch({error : MissingSubject});
            return;
        }
        if (args.message == "") {
            error_id = MissingMessage;
            this.triggers.sendFail.dispatch({error : MissingMessage});
            return;
        }
        #if php
        if (!php.Lib.mail(args.receiver, args.subject, args.message, "From: " + user.email + "\r\n")) {
            error_id = MailNotSent;
            this.triggers.sendFail.dispatch({error : MailNotSent});
            return;
        }
        #else
        error_id = OnlyPHP;
        this.triggers.sendFail.dispatch({error : OnlyPHP});
        return;
        #end
        this.triggers.sendSuccess.dispatch();
    }

    public function getErrorString(error: MailErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case MailNotSent: BelugaI18n.getKey(this.i18n, "mail_not_sent");
            case OnlyPHP: BelugaI18n.getKey(this.i18n, "not_supported");
            case MissingReceiver: BelugaI18n.getKey(this.i18n, "missing_receiver");
            case MissingSubject: BelugaI18n.getKey(this.i18n, "missing_subject");
            case MissingMessage: BelugaI18n.getKey(this.i18n, "missing_message");
            case UnknownId: BelugaI18n.getKey(this.i18n, "id_not_found");
            case None: "";
        };
    }
}