package beluga.module.mail.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;

class Default extends MttWidget<MailImpl> {

    public function new(mttfile = "beluga_mail_mail.mtt") {
        super(Mail, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/mail/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        mod.createDefaultContext();

        return {
            mails : mod.getSentMails(),
            error : (mod.error_msg != "" ? BelugaI18n.getKey(this.i18n, mod.error_msg) : mod.error_msg),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            user : Beluga.getInstance().getModuleInstance(Account).loggedUser,
            path : "/beluga/mail/"
        }
    }
}