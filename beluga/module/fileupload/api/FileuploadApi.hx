package beluga.module.fileupload.api;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.fileupload.Fileupload;

// Haxe
import haxe.web.Dispatch;

class FileuploadApi 
{
    var beluga : Beluga;
    var file_upload : Fileupload;

    public function new(beluga : Beluga, file_upload : Fileupload) {
        this.beluga = beluga;
        this.file_upload = file_upload;
    }

    public function doBrowse(): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_browse");   
    }

    public function doSend(): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_send");   
    }

    public function doDefault(): Void {
        trace("FileUpload default page");
    }

    public function doDelete(args: { id: Int }): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_delete", [args]);   
    }

    public function doAddextension(args: { name: String }): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_addextension", [args]);   
    }

    public function doDeleteextension(args: { id: Int }): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_deleteextension", [args]);   
    }

    public function doAdmin(): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_admin");   
    }

    public function doCss(d: Dispatch): Void {
        d.dispatch(new CssApi());
    }
}
