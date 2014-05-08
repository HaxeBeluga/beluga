package beluga.module.fileupload;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.account.Account;
import beluga.module.fileupload.model.File;
import beluga.module.fileupload.model.Extension;

// Haxe
import haxe.xml.Fast;
import php.Web;
import sys.io.FileOutput;

class FileuploadImpl extends ModuleImpl implements FileuploadInternal {
    public var error: String = "";

	public function new() {
        super();
    }

    override public function loadConfig(data : Fast): Void {

    }

    /** Actions trigger **/

    public static function _browse(): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).browse();
    }

    public function browse(): Void{
        beluga.triggerDispatcher.dispatch("beluga_fileupload_browse", []);
    }

    public function getBrowseContext(): Dynamic {
        var files: List<Dynamic> = new List<Dynamic>();
        var user_id: Int = 0;

        if (Beluga.getInstance().getModuleInstance(Account).isLogged()) {
            user_id = Beluga.getInstance().getModuleInstance(Account).getLoggedUser().id;
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

    public static function _send(): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).send();
    }

    public function send(): Void{
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged()) {
            beluga.triggerDispatcher.dispatch("beluga_fileupload_delete_fail", [{reason: "You cannot access this action"}]);
            return;
        }

        var id = Beluga.getInstance().getModuleInstance(Account).getLoggedUser().id;
        var login = Beluga.getInstance().getModuleInstance(Account).getLoggedUser().login;
        var up = new Uploader(login, id);
        if (up.is_valid == false) {
            beluga.triggerDispatcher.dispatch("beluga_fileupload_upload_fail", [{reason: "Invalid file extension"}]);
        } else {
            var notif = {
                title: "File transfer completed !",
                text: "Your file transfer terminate with success, you can consult your files in the file upload section !",
                user_id: Beluga.getInstance().getModuleInstance(Account).getLoggedUser().id
            };
            beluga.triggerDispatcher.dispatch("beluga_fileupload_notify_upload_success", [notif]);
            beluga.triggerDispatcher.dispatch("beluga_fileupload_delete_success", []);
        }
    }


    public function getSendContext(): Dynamic {
        return {};
    }

    public static function _delete(args: { id: Int }): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).delete(args);
    }

    public function delete(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged()) {
            beluga.triggerDispatcher.dispatch("beluga_fileupload_delete_fail", [{reason: "You cannot access this action"}]);
            return;
        } else {
            var file = File.manager.get(args.id);
            var current_user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser().id;
            if (file.fi_id_owner != current_user) {
                beluga.triggerDispatcher.dispatch("beluga_fileupload_delete_fail", [{reason: "You cannot access this action"}]);
                return;
            } else {
                file.delete();
                beluga.triggerDispatcher.dispatch("beluga_fileupload_delete_success");
            }
        }
   }

    public static function _admin(): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).admin();
    }

    public function admin(): Void {
        beluga.triggerDispatcher.dispatch("beluga_fileupload_admin", []);
    }

    public function getAdminContext(): Dynamic {
        var extensions = this.getExtensionsList();
        return {
            extensions_list: extensions,
            admin_error: this.error
        };
    }

    public static function _addextension(args: { name: String }): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).addextension(args);
    }

    public function addextension(args: { name: String }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged()) {
            this.error = "You must be logged to access this section";
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
            } else {
                this.error = "This extension already exist !";
            }
        }
        beluga.triggerDispatcher.dispatch("beluga_fileupload_addextension_success", []);
    }

    public static function _deleteextension(args: { id: Int }): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).deleteextension(args);
    }

    public function deleteextension(args: { id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged()) {
            this.error = "You must be logged to access this section";
        } else {
            var ext = null;
            for( u in Extension.manager.search($ex_id == args.id) ) {
                ext = u;
            }
            if (ext == null) {
                this.error = "This extension doesn't exist!";
            } else {
                ext.delete();
            }
        }
        beluga.triggerDispatcher.dispatch("beluga_fileupload_deleteextension_success", []);
    }

    public function extensionIsValid(name: String): Bool {
        if (Extension.manager.search($ex_name == name).length != 0) {
            return true;
        } else {
            return false;
        }
    }
}