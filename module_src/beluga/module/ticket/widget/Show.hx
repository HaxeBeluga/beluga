// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.Assignement;
import beluga.module.ticket.Ticket;
import beluga.module.account.model.User;
import beluga.module.ticket.TicketErrorKind;
import beluga.widget.Layout;

class Show extends MttWidget<Ticket> {

    public function new (?layout : Layout) {
        if(layout == null) layout = Layout.newFromPath("/beluga/module/ticket/view/tpl/show.mtt");
        super(Ticket, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/ticket/view/locale/show/", mod.i18n);
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
            ticket_error: this.getErrorString(mod.error),
            ticket_assignee: assignee,
            ticket_owner_id: User.manager.get(ticket.user_id).id
        };
    }

    private function getErrorString(error: TicketErrorKind): String {
        return switch (error) {
            case TicketUserNotLogged: BelugaI18n.getKey(i18n, "user_not_logged");
            case TicketMessageEmpty: BelugaI18n.getKey(i18n, "ticket_message_empty");
            case TicketTitleEmpty: BelugaI18n.getKey(i18n, "ticket_title_empty");
            case TicketUndefinedLabelId: BelugaI18n.getKey(i18n, "undefined_label_id");
            case TicketLabelEmpty: BelugaI18n.getKey(i18n, "ticket_label_empty");
            case TicketLabelAlreadyExist: BelugaI18n.getKey(i18n, "ticket_label_exist");
            case TicketErrorNone: "";
        };
    }
}