package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.Assignement;
import beluga.module.ticket.Ticket;
import beluga.module.account.model.User;

class Show extends MttWidget<TicketImpl> {

    public function new (mttfile = "beluga_ticket_show.mtt") {
        super(Ticket, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/show/", mod.i18n);
    }

    /// Create the context for the Show view:
    /// * retrieve all the tickets data +
    /// * all the comments associated to the ticket
    /// * then all the labels associated to the tickets
    override private function getContext(): Dynamic {
        var ticket = TicketModel.manager.get(mod.show_id);
        var messages: List<Dynamic> = new List<Dynamic>();
        var labels: List<Dynamic> = new List<Dynamic>();
        var assignee: String = "None";

        // retrieve messages informations
        messages = mod.getTicketMessages(ticket.id);

        // retrieve associated labels
        labels = mod.getTicketLabels(ticket.id);

        var assignement = Assignement.manager.search($ticket_id == ticket.id).first();
        if (assignement != null) {
            assignee = User.manager.get(assignement.user_id).login;
        }

        return {
            ticket_subject: ticket.title,
            ticket_id: ticket.id,
            ticket_message: ticket.content,
            ticket_create_date: ticket.date,
            ticket_owner: User.manager.get(ticket.user_id).login,
            ticket_message_count: messages.length,
            messages_list: messages,
            labels_list: labels,
            ticket_status: ticket.status,
            ticket_error: mod.error,
            ticket_assignee: assignee,
            ticket_owner_id: User.manager.get(ticket.user_id).id
        };    }
}