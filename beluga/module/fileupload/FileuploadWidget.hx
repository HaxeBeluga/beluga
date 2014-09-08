package beluga.module.fileupload;

import beluga.module.fileupload.widget.Admin;
import beluga.module.fileupload.widget.Browse;
import beluga.module.fileupload.widget.Send;

class FileuploadWidget {
    public var send = new Send();
    public var browse = new Browse();
    public var admin = new Admin();

    public function new() {}
}