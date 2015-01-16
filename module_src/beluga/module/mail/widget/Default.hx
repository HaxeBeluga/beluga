package beluga.module.mail.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;
import beluga.resource.ResourceManager;
import beluga.widget.Layout;

class Default extends MttWidget<Mail> {

    public function new (?layout : Layout) {
        if(layout == null) layout = Layout.newFromPath("/beluga/module/mail/view/tpl/mail.mtt");
        super(Mail, layout);
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