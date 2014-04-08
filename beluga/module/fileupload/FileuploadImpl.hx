package beluga.module.fileupload;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.account.Account;

// Haxe
import haxe.xml.Fast;

class FileuploadImpl extends ModuleImpl implements FileuploadInternal {

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
        beluga.triggerDispatcher.dispatch("beluga_file_upload_show_browse", []);
    }
}