package beluga.module.ticket.model;

// beluga mods
import beluga.module.account.model.User;
import beluga.module.ticket.model.TicketModel;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_assignement")
class Assignement extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var ticket_id: SInt;
    @:relation(user_id)
    public var user: User;
    @:relation(ticket_id)
    public var ticet: TicketModel;
}