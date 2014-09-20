package beluga.module.ticket.model;

// beluga mods
import beluga.module.account.model.User;


// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_ticket")
class TicketModel extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var date: SDateTime;
    public var path_attachment: STinyText;
    public var title: STinyText;
    public var content: STinyText;
    public var status: SInt;
    @:relation(user_id)
    public var user: User;
}