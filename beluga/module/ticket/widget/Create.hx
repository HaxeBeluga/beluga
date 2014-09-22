package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;
import beluga.module.ticket.Ticket;
import beluga.module.account.Account;

class Create extends MttWidget<TicketImpl> {

    public function new (mttfile = "beluga_ticket_create.mtt") {
        super(Ticket, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/create/", mod.i18n);
    }

    /// Returns the context for the view create ticket
    /// in the form of a List<Dynamic>
    /// { labels_list: { label_name: String }, ticket_error: String }
    override private function getContext(): Dynamic {
        var labels: List<Dynamic> = mod.getLabelsList();
        var users = Beluga.getInstance().getModuleInstance(Account).getUsers2();

        return {
            labels: labels,
            ticket_error: mod.error,
            users: users
        };
    }

}