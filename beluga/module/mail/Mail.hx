// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.mail;

import beluga.core.module.Module;
import beluga.module.mail.model.MailModel;

interface Mail extends Module {
    public var triggers: MailTrigger;

    // Context methods
    public function getDefaultContext() : Dynamic;
    public function getCreateContext() : Dynamic;
    public function getPrintContext(mail_id: Int) : Dynamic;

    // Helpful methods
    public function canPrint(mail_id: Int) : Bool;
    public function getSentMails() : Array<MailModel>;
    public function getMail(id : Int) : MailModel;
    public function getDraftMails() : Array<MailModel>;

    public function sendMail(args : {receiver : String, subject : String, message : String}) : Void;
}