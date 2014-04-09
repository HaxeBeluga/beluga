package beluga.module.fileupload.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.fileupload.Fileupload;

class CssApi {
    public function new() {}

    public function doBrowse() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Fileupload).getWidget("browse").getCss());
    }

    public function doSend() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Fileupload).getWidget("send").getCss());
    }

    public function doAdmin() {
        Web.setHeader("Content-type", "text/css");
        Sys.print(Beluga.getInstance().getModuleInstance(Fileupload).getWidget("admin").getCss());
    }
}