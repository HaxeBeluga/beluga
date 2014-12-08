// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.fileupload.Fileupload;
import beluga.I18n;
import beluga.widget.Layout;

class Send extends MttWidget<Fileupload> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/fileupload/view/tpl/send.mtt");
        super(Fileupload, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/fileupload/view/locale/admin/", mod.i18n);
    }

    override private function getContext() {
        return {
            module_name: "Send a File"
        };
    }
}