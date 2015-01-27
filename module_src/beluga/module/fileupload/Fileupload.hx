// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload;

// Haxe
import beluga.module.fileupload.api.FileuploadApi;
import haxe.xml.Fast;
import sys.io.FileOutput;

// Beluga core
import beluga.module.Module;
import beluga.Beluga;

// Beluga mods
import beluga.module.account.Account;
import beluga.module.fileupload.model.File;
import beluga.module.fileupload.model.Extension;
import beluga.I18n;
import beluga.module.fileupload.FileUploadErrorKind;

#if neko
import neko.Lib;
import neko.Web;
#elseif php
import php.Lib;
import php.Web;
#end

// import sys.io.File;


@:Css("/beluga/module/fileupload/view/css/")
class Fileupload extends Module {
    public var triggers = new FileuploadTrigger();
    public var widgets : FileuploadWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/fileupload/locale/");
    public var error: FileUploadErrorKind = FileUploadNone;

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new FileuploadWidget();
        beluga.api.register("fileupload", new FileuploadApi(beluga, this));
    }

    /// Return: {file_name: String, file_path: String, file_size: Int, file_id: Int}
    public function getUserFileList(user_id: Int): List<Dynamic> {
        var files: List<Dynamic> = new List<Dynamic>();

        for (f in File.manager.search($owner_id == user_id)) {
            try {
            files.push({
                file_name: f.name,
                file_path: f.path,
                file_size: sys.FileSystem.stat(f.path).size,
                file_id: f.id
            });
            } catch (e: Dynamic) {
                return files;
            }
        }
        return files;
    }

    /// Return: {extension_name: String, extension_id: Int}
    public function getExtensionsList(): List<Dynamic> {
        var extensions: List<Dynamic> = new List<Dynamic>();

        for (e in Extension.manager.dynamicSearch({})) {
            extensions.push({
                extension_name: e.name,
                extension_id: e.id,
            });
        }

        return extensions;
    }

    public function isValidFileExtension(filename: String): Bool {
        var splitString = filename.split(".");
        if (Extension.manager.search($name == splitString[splitString.length - 1]).length == 0) {
            return false;
        } else {
            return true;
        }
    }

    public function insertDataInDb(user: String, filename: String, id: Int) {
        var file = new beluga.module.fileupload.model.File();
        file.path = "upload/" + user + "/" + filename;
        file.size = 0;
        file.name = filename;
        file.owner_id = id;
        file.insert();
    }

    public function ensureUserFolderExist(user: String): Bool {
        var exist: Bool = false;
        var path = "upload/" + user;
        if (sys.FileSystem.exists(path) && sys.FileSystem.isDirectory(path)) {
            exist = true;
        } else { // create it
            try {
                sys.FileSystem.createDirectory(path);
                exist = true;
            } catch (e : Dynamic) {
                Sys.print(e);
                exist = false;
            }
        }

        return exist;
    }

    public function send(): Void{
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = FileUploadUserNotLogged;
            this.triggers.deleteFail.dispatch({error: this.error});
            return;
        }
        var id = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
        var login = Beluga.getInstance().getModuleInstance(Account).loggedUser.login;
        try {
            // yes this is magic
            // call nicolas cannasse if you want some help, thanks
            this.ensureUserFolderExist(login);
            var file = Web.getMultipart(10 * 1024 * 1024);
            var filename = file.get("dont_care").split("\\");
            var out = sys.io.File.write("upload/" + login + "/" + filename[filename.length - 1], true);
            out.writeString(file.get("fileupload_filename").toString());
            out.close();
            this.insertDataInDb(login, filename[filename.length - 1], id);
            this.triggers.uploadSuccess.dispatch();
        } catch (e: Dynamic) {
            this.triggers.uploadFail.dispatch({error: FileUploadInvalidFileExtension});
        }
    }

    public function delete(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = FileUploadUserNotLogged;
            this.triggers.deleteFail.dispatch({error: this.error});
            return;
        } else {
            var file = File.manager.get(args.id);
            var current_user = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
            if (file.owner_id != current_user) {
                this.error = FileUploadInvalidAccess;
                this.triggers.deleteFail.dispatch({error: this.error});
                return;
            } else {
                file.delete();
                this.triggers.deleteSuccess.dispatch();
            }
        }
   }

    public function addextension(args: { name: String }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = FileUploadUserNotLogged;
            this.triggers.addExtensionFail.dispatch({error: this.error});
        } else if (args.name == "") {
            this.error = FileUploadEmptyField;
            this.triggers.addExtensionFail.dispatch({error: this.error});
        } else {
            var ext = null;
            for( u in Extension.manager.search($name == args.name) ) {
                ext = u;
            }
            if (ext == null) {
                var extension = new Extension();
                extension.name = args.name;
                extension.insert();
                this.triggers.addExtensionSuccess.dispatch();
            } else {
                this.error = FileUploadExtensionExist;
                this.triggers.addExtensionFail.dispatch({error: this.error});
            }
        }
    }

    public function deleteextension(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = FileUploadUserNotLogged;
            this.triggers.deleteExtensionFail.dispatch({error: this.error});
        } else {
            var ext = null;
            for( u in Extension.manager.search($id == args.id) ) {
                ext = u;
            }
            if (ext == null) {
                this.error = FileUploadExtensionDontExist;
                 this.triggers.deleteExtensionFail.dispatch({error: this.error});
            } else {
                ext.delete();
                this.triggers.deleteExtensionSuccess.dispatch();
            }
        }
    }

    public function extensionIsValid(name: String): Bool {
        if (Extension.manager.search($name == name).length != 0) {
            return true;
        } else {
            return false;
        }
    }
}