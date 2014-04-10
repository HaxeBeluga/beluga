package beluga.module.wallet.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.wallet.Wallet;

class CssApi {
    public function new() {}

    public function doDisplay() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Wallet).getWidget("display").getCss());
    }

    public function doDisplayAdmin() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Wallet).getWidget("display_admin").getCss());
    }
}