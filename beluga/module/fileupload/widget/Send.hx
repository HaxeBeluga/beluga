package beluga.module.fileupload.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.fileupload.Fileupload;

class Send extends MttWidget<FileuploadImpl> {

    public function new (mttfile = "beluga_fileupload_send.mtt") {
        super(Fileupload, mttfile);
    }

    override private function getContext() {
        var context = mod.getSendContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }
}