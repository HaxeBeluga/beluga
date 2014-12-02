// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.widget;

import beluga.Beluga;
import beluga.html.TypeGenerator;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.account.Account;
import beluga.tool.JsonTool;
import beluga.I18n;
import beluga.tool.DynamicTool;
import beluga.widget.Layout;

class ConfigWidget extends MttWidget<Account> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/account/view/tpl/config.mtt");
        super(Account, layout);
    }

    override private function getContext(): Dynamic {
        var context = {
            error: null,
            generated_field: TypeGenerator.parse({
                nom : "Alexis Brissard",
                homme: true,
                adresse: {
                    ligne1: "86 rue de wattignies",
                    code_postal: "75012",
                    ville: "Paris"
                }
            })
        };
        return context;
    }
}
