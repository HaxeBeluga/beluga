package beluga.module.fileupload.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.fileupload.Fileupload;

class Browse extends MttWidget {
    var mod : Fileupload;

    public function new (mttfile = "beluga_fileupload_browse.mtt") {
        super(mttfile);
        mod = Beluga.getInstance().getModuleInstance(Fileupload);
    }

    override private function getContext() {
        var context = mod.getBrowseContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}