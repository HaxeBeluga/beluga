package beluga.module.ticket;
import beluga.module.ticket.widget.Browse;
import beluga.module.ticket.widget.Create;
import beluga.module.ticket.widget.Show;
import beluga.module.ticket.widget.Admin;

class TicketWidget {
    public var browse = new Browse();
    public var create = new Create();
    public var show = new Show();
    public var admin = new Admin();

    public function new() {}
}