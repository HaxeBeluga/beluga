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

import beluga.module.account.Account;
import beluga.module.mail.model.MailModel;

class MailImpl extends ModuleImpl implements MailInternal {
    public var triggers = new MailTrigger();

    // Context variables
    private var error_msg : String;
    private var success_msg : String;
    private var receiver : String;
    private var subject : String;
    private var message : String;

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
    }

    override public function initialize(beluga : Beluga) : Void {

    }

    public function getDefaultContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null && error_msg == "") {
            error_msg = "You have to be logged to use this module";
        }
        return {mails : this.getSentMails(), user : user, error : error_msg, success : success_msg, path : "/beluga/mail/"}
    }

    public function getCreateContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        return {user : user, error : error_msg, success : success_msg, path : "/beluga/mail/",
                            receiver : receiver, subject : subject, message : message};
    }

    public function getPrintContext(mail_id: Int) : Dynamic {
        var mail = this.getMail(mail_id);

        return {path : "/beluga/mail/", receiver : mail.receiver, subject : mail.subject, text : mail.text, date : mail.sentDate};
    }

    public function canPrint(mail_id: Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "You have to log in";
            return false;
        }
        var mail = this.getMail(mail_id);

        if (mail == null) {
            error_msg = "Unknown mail";
            return false;
        }
        return true;
    }

    public function getMail(id : Int) : MailModel {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in MailModel.manager.dynamicSearch( {user_id : user.id, id : id} ))
                return tmp;
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
            error_msg = "You must be logged in to send mail";
            this.triggers.sendFail.dispatch();
            return;
        }
        #if php
        if (!php.Lib.mail(args.receiver, args.subject, args.message, "From: " + user.email + "\r\n")) {
            error_msg = "Mail hasn't been sent";
            this.triggers.sendFail.dispatch();
            return;
        }
        #else
        error_msg = "Only working with php (for the moment...)";
        this.triggers.sendFail.dispatch();
        return;
        #end
        this.triggers.sendSuccess.dispatch();
    }
}