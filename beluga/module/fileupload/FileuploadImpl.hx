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

class FileuploadImpl extends ModuleImpl implements FileuploadInternal {
    private var error: String = "";

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
            files_list: files
        };
    }

    /// Return: {file_name: String, file_path: String, file_size: Int, file_id: Int}
    public function getUserFileList(user_id: Int): List<Dynamic> {
        var files: List<Dynamic> = new List<Dynamic>();
        
        for (f in File.manager.search($fi_id_owner == user_id)) {
            files.push({ 
                file_name: f.fi_name,
                file_path: f.fi_path,
                file_size: f.fi_size,
                file_id: f.fi_id 
            });
        }
        return files;
    }

    public static function _send(): Void {
        Beluga.getInstance().getModuleInstance(Fileupload).send();
    }
 
    public function send(): Void{
        beluga.triggerDispatcher.dispatch("beluga_fileupload_send", []);
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


}