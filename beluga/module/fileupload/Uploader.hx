package beluga.module.fileupload;

import sys.io.FileOutput;
import sys.io.File;
import haxe.io.Bytes;

import beluga.module.fileupload.model.Extension;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end


class Uploader {
    public var user: String = "";
    public var filename: String = "";
    public var is_valid: Bool;
    public var file_path: String = "";
    public var id: Int = 0;

    public function isValidFileExtension(filename: String): Bool {
        var splitString = filename.split(".");
        if (Extension.manager.search($name == splitString[splitString.length - 1]).length == 0) {
            this.is_valid = false;
            return false;
        } else {
            this.is_valid = true;
            return true;
        }
    }

    public function insertDataInDb() {

        var file = new beluga.module.fileupload.model.File();
        file.path = "upload/" + user + "/" + filename;
        file.size = 0;
        file.name = this.filename;
        file.owner_id = this.id;
        file.insert();
    }

    public function new(user: String, id: Int)
    {
        var output = null;
        var filename = "";
        this.id = id;
        this.user = user;

        Web.parseMultipart (
            function(partName:String, fileName:String) {
                filename = fileName;
                this.filename = filename;
            },
            function (data:Bytes, pos:Int, len:Int) {
                if (filename != "") {
                    if (this.isValidFileExtension(filename)) {
                        if (!sys.FileSystem.exists("upload/" + user + "/")) {
                            sys.FileSystem.createDirectory("upload/" + user + "/");
                            this.file_path = "upload/" + user + "/" + filename;
                        }
                        output = File.write ("upload/" + user + "/" + filename, true);
                        output.write (data);
                        this.insertDataInDb();
                    }
                }
            }
        );

    }
}