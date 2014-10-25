// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;
import beluga.module.ticket.Ticket;
import beluga.module.account.Account;
import beluga.module.ticket.TicketErrorKind;
import beluga.core.ResourceManager;

class Create extends MttWidget<TicketImpl> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/ticket/view/tpl/create.mtt");
        super(Ticket, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/locale/create/", mod.i18n);
    }

    /// Returns the context for the view create ticket
    /// in the form of a List<Dynamic>
    /// { labels_list: { label_name: String }, ticket_error: String }
    override private function getContext(): Dynamic {
        var labels: List<Dynamic> = mod.getLabelsList();
        var users = Beluga.getInstance().getModuleInstance(Account).getUsers2();

        return {
            labels: labels,
            ticket_error: this.getErrorString(mod.error),
            users: users
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