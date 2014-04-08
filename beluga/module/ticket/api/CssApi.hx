package beluga.module.ticket.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.ticket.Ticket;

class CssApi {
    public function new() {}

    public function doBrowse() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Ticket).getWidget("browse").getCss());
    }

    public function doCreate() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Ticket).getWidget("create").getCss());
    }

    public function doShow() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Ticket).getWidget("show").getCss());
    }
}