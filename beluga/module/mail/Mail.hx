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
    public var widgets : MailWidget;

    // Context methods
    public function createDefaultContext() : Void;
    public function setActualMail(mail_id : Int) : Void;
    public function getActualMail() : MailModel;

    // Helpful methods
    public function canPrint() : Bool;
    public function getSentMails() : Array<MailModel>;
    public function getMail(id : Int) : MailModel;
    public function getDraftMails() : Array<MailModel>;

    public function sendMail(args : {receiver : String, subject : String, message : String}) : Void;
}