package beluga.module.notification.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.notification.Notification;
import beluga.module.notification.NotificationErrorKind;
import beluga.module.account.Account;
import beluga.core.ResourceManager;

class Default extends MttWidget<Notification> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/notification/view/tpl/notification.mtt");
        super(Notification, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/notification/view/locale/default/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            mod.error_id = MissingLogin;
        }
        return {
            notifs : mod.getNotifications(),
            user : user,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/notification/"
        };
    }
}