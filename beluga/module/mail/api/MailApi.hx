package beluga.module.mail.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.mail.Mail;
import haxe.web.Dispatch;

class MailApi
{
	var beluga : Beluga;
	var mail : Mail;

	public function new(beluga : Beluga, mail : Mail) {
		this.beluga = beluga;
		this.mail = mail;
	}

	public function doDefault() {
		beluga.triggerDispatcher.dispatch("beluga_mail_default", []);
	}

	public function doCreate() {
		beluga.triggerDispatcher.dispatch("beluga_mail_create", []);
	}

	public function doSend(args : {receiver : String, subject : String, message : String}) {
		beluga.triggerDispatcher.dispatch("beluga_mail_send", [args]);
	}

	public function doPrint(args : {id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_mail_print", [args]);
	}
}
