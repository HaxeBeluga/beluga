// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

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
        this.module.setActualMail(args.id);
        this.module.triggers.print.dispatch();
    }
}
