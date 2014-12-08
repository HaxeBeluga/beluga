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
import beluga.widget.Layout;

class Browse extends MttWidget<Ticket> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/ticket/view/tpl/browse.mtt");
        super(Ticket, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/ticket/view/locale/browse/", mod.i18n);
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
            closed_tickets: tickets.closed,
            module_name: "Ticket browse"
        };
    }
}