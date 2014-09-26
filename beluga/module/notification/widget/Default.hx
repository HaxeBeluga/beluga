package beluga.module.notification.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.notification.Notification;
import beluga.module.notification.NotificationErrorKind;
import beluga.module.account.Account;

class Default extends MttWidget<NotificationImpl> {

    public function new(mttfile = "beluga_notification_notification.mtt") {
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