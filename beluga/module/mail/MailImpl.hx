package beluga.module.mail;

import haxe.xml.Fast;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;

import beluga.module.account.Account;
import beluga.module.mail.model.MailModel;

class MailImpl extends ModuleImpl implements MailInternal {
    public var triggers = new MailTrigger();

    public function new() {
        super();
    }

	override public function initialize(beluga : Beluga) : Void {

	}

	#if (php || neko)
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

        if (user == null) {
            this.triggers.sendFail.dispatch({error : "You must log in to send mail", receiver : args.receiver, subject : args.subject, message : args.message});
            return;
        }
        var receiver:String = "";
        #if php
        var sender:String = user.email;
        var ret:Bool=false;
        untyped __php__("$sender = filter_var($sender, FILTER_SANITIZE_EMAIL)");
        ret = untyped __php__("filter_var($sender, FILTER_VALIDATE_EMAIL)");
        if (!ret) {
            this.triggers.sendFail.dispatch({error : "Error on sender email", receiver : args.receiver, subject : args.subject, message : args.message});
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
                this.triggers.sendSuccess.dispatch();
                return;
            }
            this.triggers.sendFail.dispatch({error : "Error when sending mail", receiver : receiver, subject : args.subject, message : args.message});
            return;
        }
        this.triggers.sendFail.dispatch({error : "Error on receiver email", receiver : receiver, subject : args.subject, message : args.message});
        #else
        this.triggers.sendFail.dispatch({error : "Only working with php", receiver : receiver, subject : args.subject, message : args.message});
        return;
        #end
        this.triggers.sendFail.dispatch({error : "error", receiver : receiver, subject : args.subject, message : args.message});
    }
	#end
}