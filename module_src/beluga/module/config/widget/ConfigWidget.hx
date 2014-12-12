// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.config.widget;

import beluga.Beluga;
import beluga.html.TypeGenerator;
import beluga.widget.MttWidget;
import beluga.I18n;
import beluga.widget.Layout;

class ConfigWidget extends MttWidget<Config> {

    var get : Void -> Dynamic;
    var save_url : String;

    public function new (?layout : Layout, get : Void->Dynamic, save_url : String ) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/config/view/tpl/config.mtt");
        super(Config, layout);
        this.get = get;
        this.save_url = save_url;
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/config/view/locale/config/");
    }

    override private function getContext(): Dynamic {
        var context = {
            error: null,
            generated_field: TypeGenerator.parse(get()),
            save_url: save_url
        };
        return context;
    }
}
