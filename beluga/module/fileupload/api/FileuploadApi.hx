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
        beluga.triggerDispatcher.dispatch("beluga_file_upload_browse");   
    }

    public function doDefault(): Void {
        trace("FileUpload default page");
    }

    // public function doCss(d: Dispatch): Void {
    //     d.dispatch(new CssApi());
    // }
}
