package beluga.module.fileupload.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.fileupload.Fileupload;

class Admin extends MttWidget {
    var mod : Fileupload;

    public function new (mttfile = "beluga_fileupload_admin.mtt") {
        super(mttfile);
        mod = Beluga.getInstance().getModuleInstance(Fileupload);
    }

    override private function getContext() {
        var context = mod.getAdminContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}