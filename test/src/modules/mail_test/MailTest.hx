// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.mail_test;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.mail.Mail;
import beluga.module.mail.MailErrorKind;
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
        this.mail.triggers.sendFail.add(this.sendFail);
        this.mail.triggers.sendSuccess.add(this.doDefault);
        this.mail.triggers.create.add(this.create);
        this.mail.triggers.print.add(this.print);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_mail", "Mails list", {
            mailWidget: mail.widgets.mail.render()
        });
        Sys.print(html);
    }

    public function create() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            this.doDefault();
        } else {
            var html = Renderer.renderDefault("page_mail", "Mails list", {
                mailWidget: mail.widgets.create.render()
            });
            Sys.print(html);
        }
    }

    public function sendFail(args : {error : MailErrorKind}) {
        this.create();
    }

    public function print() {
        if (!mail.canPrint()) {
            this.doDefault();
        } else {
            var html = Renderer.renderDefault("page_mail", "Mails list", {
                mailWidget: mail.widgets.print.render()
            });
            Sys.print(html);
        }
    }
}