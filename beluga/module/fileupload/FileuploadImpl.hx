package beluga.module.fileupload;

// Haxe
import haxe.xml.Fast;
import sys.io.FileOutput;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.account.Account;
import beluga.module.fileupload.model.File;
import beluga.module.fileupload.model.Extension;

#if php
import php.Web;
#end

class FileuploadImpl extends ModuleImpl implements FileuploadInternal {
    public var error: String = "";
    public var triggers = new FileuploadTrigger();
    public var widgets : FileuploadWidget;

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new FileuploadWidget();
    }

    public function getBrowseContext(): Dynamic {
        var files: List<Dynamic> = new List<Dynamic>();
        var user_id: Int = 0;

        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            user_id = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
            files = this.getUserFileList(user_id);
        } else {
            this.error = "You must be logged to access this page";
        }
        return {
            file_error: this.error,
            files_list: files,
        };
    }

    /// Return: {file_name: String, file_path: String, file_size: Int, file_id: Int}
    public function getUserFileList(user_id: Int): List<Dynamic> {
        var files: List<Dynamic> = new List<Dynamic>();

        for (f in File.manager.search($fi_id_owner == user_id)) {
            files.push({
                file_name: f.fi_name,
                file_path: f.fi_path,
                file_size: sys.FileSystem.stat(f.fi_path).size,
                file_id: f.fi_id
            });
        }
        return files;
    }

    /// Return: {extension_name: String, extension_id: Int}
    public function getExtensionsList(): List<Dynamic> {
        var extensions: List<Dynamic> = new List<Dynamic>();

        for (e in Extension.manager.search($ex_id < 100)) {
            extensions.push({
                extension_name: e.ex_name,
                extension_id: e.ex_id,
            });
        }

        return extensions;
    }

    public function send(): Void{
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.triggers.deleteFail.dispatch({reason: "You cannot access this action"});
            return;
        }

        var id = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
        var login = Beluga.getInstance().getModuleInstance(Account).loggedUser.login;
        var up = new Uploader(login, id);
        if (up.is_valid == false) {
            this.triggers.uploadFail.dispatch({reason: "Invalid file extension"});
        } else {
            var notif = {
                title: "File transfer completed !",
                text: "Your file transfer terminate with success, you can consult your files in the file upload section !",
                user_id: Beluga.getInstance().getModuleInstance(Account).loggedUser.id
            };
            this.triggers.uploadSuccess.dispatch(notif);
        }
    }


    public function getSendContext(): Dynamic {
        return {};
    }

    public function delete(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.triggers.deleteFail.dispatch({reason: "You cannot access this action"});
            return;
        } else {
            var file = File.manager.get(args.id);
            var current_user = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
            if (file.fi_id_owner != current_user) {
                this.triggers.deleteFail.dispatch({reason: "You cannot access this action"});
                return;
            } else {
                file.delete();
                this.triggers.deleteSuccess.dispatch();
            }
        }
   }

    public function getAdminContext(): Dynamic {
        var extensions = this.getExtensionsList();
        return {
            extensions_list: extensions,
            admin_error: this.error
        };
    }

    public function addextension(args: { name: String }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = "You must be logged to access this section";
            this.triggers.addExtensionFail.dispatch();
        } else if (args.name == "") {
            this.error = "The field is empty";
        } else {
            var ext = null;
            for( u in Extension.manager.search($ex_name == args.name) ) {
                ext = u;
            }
            if (ext == null) {
                var extension = new Extension();
                extension.ex_name = args.name;
                extension.insert();
                this.triggers.addExtensionSuccess.dispatch();
            } else {
                this.error = "This extension already exist !";
                this.triggers.addExtensionFail.dispatch();
            }
        }
    }

    public function deleteextension(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = "You must be logged to access this section";
            this.triggers.deleteExtensionFail.dispatch();
        } else {
            var ext = null;
            for( u in Extension.manager.search($ex_id == args.id) ) {
                ext = u;
            }
            if (ext == null) {
                this.error = "This extension doesn't exist!";
                 this.triggers.deleteExtensionFail.dispatch();
            } else {
                ext.delete();
                this.triggers.deleteExtensionSuccess.dispatch();
            }
        }
    }

    public function extensionIsValid(name: String): Bool {
        if (Extension.manager.search($ex_name == name).length != 0) {
            return true;
        } else {
            return false;
        }
    }
}