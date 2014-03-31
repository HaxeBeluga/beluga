package beluga.module.ticket.api;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.ticket.Ticket;

// Haxe
import haxe.web.Dispatch;

class TicketApi 
{
    var beluga : Beluga;
    var ticket : Ticket;

    public function new(beluga : Beluga, ticket : Ticket) {
        this.beluga = beluga;
        this.ticket = ticket;
    }

    public function doBrowse() {
        beluga.triggerDispatcher.dispatch("beluga_ticket_browse");
        
    }

    public function doCreate() {
        beluga.triggerDispatcher.dispatch("beluga_ticket_create");
    }
    
    public function doDefault() {
        trace("Ticket default page");
    }

    public function doCss(d: Dispatch) {
        d.dispatch(new CssApi());
    }

}
