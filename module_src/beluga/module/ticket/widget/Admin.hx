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
import beluga.module.ticket.Ticket;
import beluga.I18n;
import beluga.module.ticket.TicketErrorKind;
import beluga.widget.Layout;

class Admin extends MttWidget<Ticket> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/ticket/view/tpl/admin.mtt");
        super(Ticket, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/ticket/view/locale/admin/", mod.i18n);
    }

    /// Returns the context for the admin widget in the form of a List<Dynamic>
    /// { admin_error: String, labels_list: { label_name: String, label_id: Int } }
    override private function getContext() {
      return {
            error: this.getErrorString(mod.error),
            labels: mod.getLabelsList(),
            module_name: "Ticket admin"
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