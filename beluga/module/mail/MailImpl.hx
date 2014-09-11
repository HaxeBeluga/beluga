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
        var receiver:String = "";
        #if php
        var sender:String = user.email;
        var ret:Bool=false;
        untyped __php__("$sender = filter_var($sender, FILTER_SANITIZE_EMAIL)");
        ret = untyped __php__("filter_var($sender, FILTER_VALIDATE_EMAIL)");
        if (!ret) {
            error_msg = "Error on sender email";
            this.triggers.sendFail.dispatch();
            return;
        }
        receiver = args.receiver;
        untyped __php__("$receiver = filter_var($receiver, FILTER_SANITIZE_EMAIL)");
        ret = untyped __php__("filter_var($receiver, FILTER_VALIDATE_EMAIL)");
        if (ret) {
            var msg = untyped __call__("wordwrap", args.text, 70);
            ret = untyped __call__("mail", args.receiver, args.subject, msg, "From: " + sender + "\n");

            if (ret) {
                var mail = new MailModel();

                mail.subject = args.subject;
                mail.text = args.message;
                mail.receiver = receiver;
                mail.user_id = user.id;
                mail.sentDate = Date.now();
                mail.hasBeenSent = false;
                mail.hasBeenSent = true;
                mail.insert();
                success_msg = "Mail has been sent successfully";
                this.triggers.sendSuccess.dispatch();
                return;
            }
            error_msg = "Error when sending mail";
            this.triggers.sendFail.dispatch();
            return;
        }
        error_msg = "Error on receiver email";
        this.triggers.sendFail.dispatch();
        #else
        error_msg = "Only working with php (for the moment...)";
        this.triggers.sendFail.dispatch();
        return;
        #end
        error_msg = "Unknow error...";
        this.triggers.sendFail.dispatch();
    }
}