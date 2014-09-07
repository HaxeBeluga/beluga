package beluga.module.mail.api;

import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

import beluga.module.mail.Mail;

class MailApi {
    public var beluga : Beluga;
    public var module : Mail;

    public function new() {}

    public function doDefault() {
        this.module.triggers.defaultMail.dispatch();
    }

    public function doCreate() {
        this.module.triggers.create.dispatch();
    }

    public function doSend(args : {receiver : String, subject : String, message : String}) {
        this.module.sendMail(args);
    }

    public function doPrint(args : {id : Int}) {
        this.module.triggers.print.dispatch(args);
    }
}
