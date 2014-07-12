package beluga.module.fileupload.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.fileupload.Fileupload;

class FileuploadApi {
    public var beluga : Beluga;
    public var module : Fileupload;

    public function new() {
    }

    public function doBrowse(): Void {}

    public function doSend(): Void {
        module.send();
    }

    public function doDefault(): Void {
        trace("FileUpload default page");
    }

    public function doDelete(args: { id: Int }): Void {
        module.delete(args);
    }

    public function doAddextension(args: { name: String }): Void {
        module.addextension(args);
    }

    public function doDeleteextension(args: { id: Int }): Void {
        module.deleteextension(args);
    }
}
