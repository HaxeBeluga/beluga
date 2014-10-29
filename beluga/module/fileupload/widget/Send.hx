// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.fileupload.Fileupload;
import beluga.core.BelugaI18n;
import beluga.core.ResourceManager;

class Send extends MttWidget<Fileupload> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/module/fileupload/view/tpl/send.mtt");
        super(Fileupload, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/fileupload/view/locale/admin/", mod.i18n);
    }

    override private function getContext() {
        return {};
    }
}