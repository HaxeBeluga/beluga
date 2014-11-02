package beluga.module.notification.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.notification.Notification;
import beluga.module.notification.NotificationErrorKind;
import beluga.module.account.Account;
import beluga.resource.ResourceManager;
import beluga.resource.ResourceManager;

class Print extends MttWidget<Notification> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/notification/view/tpl/print_notif.mtt");
        super(Notification, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/notification/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (mod.canPrint(mod.actual_notif_id)) {
            var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

            return {
                notif : mod.getNotification(mod.actual_notif_id, user.id),
                path : "/beluga/notification/"
            };
        }
        var ret = mod.widgets.notification.getContext();

        ret.other = mod.widgets.notification.render();
        return ret;
    }
}