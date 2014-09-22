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

    /// Set the context informations for the browse widget:
    /// * Tickets informations
    /// * closed / open tickets
    /// * Existings labels
    override private function getContext(): Dynamic {
        var tickets = mod.getTickets();
        // Store all labels names in a dynamic
        var labels = mod.getLabelsList();

        return {
            tickets_list: tickets.list,
            labels_list: labels,
            open_tickets: tickets.open,
            closed_tickets: tickets.closed
        };
    }
}