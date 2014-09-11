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

class MailTest {
    public var beluga(default, null) : Beluga;
    public var mail(default, null) : Mail;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.mail = beluga.getModuleInstance(Mail);

        this.mail.triggers.defaultMail.add(this.doDefault);
        this.mail.triggers.sendFail.add(this.create);
        this.mail.triggers.sendSuccess.add(this.doDefault);
        this.mail.triggers.create.add(this.create);
        this.mail.triggers.print.add(this.print);
    }

    public function doDefault() {
        var widget = mail.getWidget("mail");

        widget.context = mail.getDefaultContext();
        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: widget.render()
        });
        Sys.print(html);
    }

    public function create() {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.doDefault();
            return;
        }
        var widget = mail.getWidget("sendMail");

        widget.context = mail.getCreateContext();
        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: widget.render()
        });
        Sys.print(html);
    }

    public function print(args : {id : Int}) {
        if (!mail.canPrint(args.id)) {
            this.doDefault();
        } else {
            var widget = this.mail.getWidget("print");

            widget.context = mail.getPrintContext(args.id);
            var html = Renderer.renderDefault("page_mail", "Mails list", {
                mailWidget: widget.render()
            });
            Sys.print(html);
        }
    }
}