package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.ticket.Ticket;
import beluga.core.BelugaI18n;

class Admin extends MttWidget<TicketImpl> {
    public function new (mttfile = "beluga_ticket_admin.mtt") {
        super(Ticket, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/admin/", mod.i18n);
    }

    /// Returns the context for the admin widget in the form of a List<Dynamic>
    /// { admin_error: String, labels_list: { label_name: String, label_id: Int } }
    override private function getContext() {
      return {
            error: mod.error,
            labels: mod.getLabelsList()
        };
    }

}