package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.ticket.Ticket;
import beluga.core.BelugaI18n;

class Browse extends MttWidget<TicketImpl> {

    public function new (mttfile = "beluga_ticket_browse.mtt") {
        super(Ticket, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/browse/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        return mod.getBrowseContext();
    }
}