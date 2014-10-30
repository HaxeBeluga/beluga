package beluga.module.mail.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;
import beluga.core.ResourceManager;

class Default extends MttWidget<Mail> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/mail/view/tpl/mail.mtt");
        super(Mail, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/mail/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        mod.createDefaultContext();

        return {
            mails : mod.getSentMails(),
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            user : Beluga.getInstance().getModuleInstance(Account).loggedUser,
            path : "/beluga/mail/"
        }
    }
}