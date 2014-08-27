package beluga.module.ticket.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.ticket.Ticket;

class TicketApi {
    public var beluga : Beluga;
    public var module : Ticket;

    public function new() {}

    public function doBrowse(): Void {
        module.browse();
    }

    public function doShow(args: { id: Int }): Void {
        module.show(args);
    }

    public function doClose(args: { id: Int }): Void {
        module.close(args);
    }

    public function doReopen(args: { id: Int }): Void {
        module.reopen(args);
    }

    public function doComment(args: { id: Int, message: String }): Void {
        module.comment(args);
    }

    public function doCreate(): Void {
        module.create();
    }

    public function doSubmit(args: { title: String, message: String, assignee: String }): Void {
        module.submit(args);
    }

    public function doAdmin(): Void {
        module.admin();
    }

    public function doDeletelabel(args: { id: Int }): Void {
        module.deletelabel(args);
    }

    public function doAddlabel(args: { name: String }): Void {
        module.addlabel(args);
    }

    public function doDefault(): Void {
        trace("Ticket default page");
    }
}
