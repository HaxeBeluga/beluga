package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.ticket.Ticket;
import beluga.core.BelugaI18n;

class Admin extends MttWidget<TicketImpl> {
    public function new (mttfile = "beluga_ticket_admin.mtt") {
        super(mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/admin/", mod.i18n);
    }

    override private function getContext() {
        var context = mod.getAdminContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }

}