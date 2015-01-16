// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.market.Market;
import beluga.widget.Layout;

class Admin extends MttWidget<Market> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/market/view/tpl/admin.mtt");
        super(Market, layout);
    }

    override private function getContext(): Dynamic {
        return {
            module_name: "Market admin"
        };
    }
}