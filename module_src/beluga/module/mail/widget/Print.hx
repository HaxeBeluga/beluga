package beluga.module.mail.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.mail.Mail;
import beluga.module.account.Account;
import beluga.widget.Layout;

class Print extends MttWidget<Mail> {

    public function new (?layout : Layout) {
        if(layout == null) layout = Layout.newFromPath("/beluga/module/mail/view/tpl/print.mtt");
        super(Mail, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/mail/view/locale/print/", mod.i18n);
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