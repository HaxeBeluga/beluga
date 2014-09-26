package beluga.module.mail.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;

class Print extends MttWidget<MailImpl> {

    public function new(mttfile = "beluga_mail_print.mtt") {
        super(Mail, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/mail/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (!mod.canPrint()) {
            return mod.widgets.mail.render();
        }
        var mail = mod.getActualMail();

        if (mail != null) {
            return {
                user : Beluga.getInstance().getModuleInstance(Account).loggedUser,
                error : mod.getErrorString(mod.error_id),
                success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
                path : "/beluga/mail/",
                receiver : mail.receiver,
                subject : mail.subject,
                text : mail.text, 
                date : mail.sentDate
            }
        } else {
            return {
                user : Beluga.getInstance().getModuleInstance(Account).loggedUser,
                error : mod.getErrorString(mod.error_id),
                success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
                path : "/beluga/mail/"
            }
        }
    }
}