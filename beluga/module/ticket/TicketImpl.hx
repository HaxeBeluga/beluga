package beluga.module.ticket;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.Label;

// Haxe
import haxe.xml.Fast;

/**
 * Implementation of the ticket system.
 * 
 * @author Valentin & Jeremy
 */
class TicketImpl extends ModuleImpl implements TicketInternal {

    public function new() {
        super();
    }
    
    override public function loadConfig(data : Fast) {
        
    }
    
    /** Actions trigger **/

    /// Set the context informations for the browse widget:
    /// * Tickets informations
    /// * closed / open tickets
    /// * Existings labels
    public function getBrowseContext(): Dynamic {
        var tickets: List<Dynamic> = new List<Dynamic>();
        var labels: List<Dynamic> = new List<Dynamic>();
        var open: Int = 0;
        var closed: Int = 0;
        var status: String = "open";

        // Store all tickets in a Dynamic
        for( t in TicketModel.manager.search($ti_id < 10000) ) {

            // retrieve ticket status
            if (t.ti_status == 1) { status = "open"; }
            else { status = "closed"; }

            // insert tickets data
            tickets.push({
                ticket_owner: User.manager.get(t.ti_us_id).login,
                ticket_subject: t.ti_title,
                ticket_date: t.ti_date,
                ticket_id: t.ti_id,
                ticket_status: status
            });

            // count closed / open tickets
            if (t.ti_status == 1) { open += 1; } 
            else { closed += 1; }
        }
        // Store all labels names in a dynamic
        for (l in Label.manager.search($la_id < 100)) {
            labels.push({ label: l.la_name });
        }
        return { 
            tickets_list: tickets, 
            labels_list: labels, 
            open_tickets: open,
            closed_tickets: closed
        };
    }

    public function getBrowseCreate(): Dynamic {
        return {};
    }

    public function getBrowseShow(): Dynamic {
        return {};
    }

    public static function _browse() {
        Beluga.getInstance().getModuleInstance(Ticket).browse();
    }
 
    public function browse() {
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_browse", []);
    }

    public static function _create() {
        Beluga.getInstance().getModuleInstance(Ticket).create();
    }

    // Web.setHeader("Content-Type", "text/plain");
    //  Sys.println("TicketDemo.doBrowseSuccess !");    
    public function create() {
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_create", []);
    }
}