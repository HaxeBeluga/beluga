package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.ticket.Ticket;

class Browse extends MttWidget<TicketImpl> {

    public function new (mttfile = "beluga_ticket_browse.mtt") {
        super(Ticket, mttfile);
    }

    override private function getContext() {
        var context = mod.getBrowseContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}