package beluga.module.notification.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.notification.Notification;
import beluga.module.notification.NotificationErrorKind;
import beluga.module.account.Account;
import beluga.widget.Layout;

class Default extends MttWidget<Notification> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/notification/view/tpl/notification.mtt");
        super(Notification, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/notification/view/locale/default/", mod.i18n);
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
            path : "/beluga/notification/",
            module_name: "Notifications"
        };
    }
}