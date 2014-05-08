package beluga.module.market.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.market.Market;

class CssApi {
    public function new() {}

    public function doDisplay() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Market).getWidget("display").getCss());
    }

    public function doAdmin() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Market).getWidget("admin").getCss());
    }
}