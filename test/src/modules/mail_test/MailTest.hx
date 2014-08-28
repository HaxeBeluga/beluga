package modules.mail_test;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.mail.Mail;
import beluga.module.account.Account;

// BelugaTest
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#end

class MailTest implements MetadataReader {
    public var beluga(default, null) : Beluga;
    public var mail(default, null) : Mail;
    private var error_msg : String;
    private var success_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.mail = beluga.getModuleInstance(Mail);
        this.mail.triggers.sendFail.add(this.doSendFail);
        this.mail.triggers.sendSuccess.add(this.doSendSuccess);
        this.mail.triggers.create.add(this.doCreate);
        this.error_msg = "";
        this.success_msg = "";
    }

    public static function _doDefault() {
       new MailTest(Beluga.getInstance()).doDefault();
    }

    public function doDefault() {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var widget = mail.getWidget("mail");
        widget.context = {mails : mail.getSentMails(), user : user, error : error_msg, success : success_msg, path : "/mailTest/"};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }

    public function subCreate(args : {receiver : String, subject : String, message : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.doDefault();
            return;
        }
        var widget = mail.getWidget("sendMail");
        widget.context = {user : user, error : error_msg, success : success_msg, path : "/mailTest/",
                            receiver : args.receiver, subject : args.subject, message : args.message};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }

    public function doCreate() {
        this.subCreate({receiver : "", subject : "", message : ""});
    }

    public function doSend(args : {receiver : String, subject : String, message : String}) {
        this.mail.sendMail(args);
    }

    public function doSendFail(args : {error : String, receiver : String, subject : String, message : String}) {
        this.error_msg = args.error;
        this.subCreate({receiver : args.receiver, subject : args.subject, message : args.message});
    }

    public function doSendSuccess() {
        success_msg = "Mail has been sent successfully";
        this.doDefault();
    }

    public function doPrint(args : {id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_msg = "You have to log in";
            this.doDefault();
            return;
        }
        var mail = this.mail.getMail(args.id);
        if (mail == null) {
            error_msg = "Unknown mail";
            this.doDefault();
            return;
        }
        var widget = this.mail.getWidget("print");
        widget.context = {path : "/mailTest/", receiver : mail.receiver, subject : mail.subject, text : mail.text, date : mail.sentDate};

        var mailWidget = widget.render();

        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mailWidget
        });
        Sys.print(html);
    }
}