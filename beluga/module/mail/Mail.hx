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