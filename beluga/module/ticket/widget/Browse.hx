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
import beluga.module.ticket.Ticket;
import beluga.core.BelugaI18n;
import beluga.core.ResourceManager;

class Browse extends MttWidget<TicketImpl> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/ticket/view/tpl/browse.mtt");
        super(mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/locale/browse/", mod.i18n);
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