package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_tic_ticketlabel")
@:id(tl_id)
class TicketLabel extends Object {
    public var tl_id: SId;
    public var tl_label_id: SInt;
    public var tl_ticket_id: SInt;
}