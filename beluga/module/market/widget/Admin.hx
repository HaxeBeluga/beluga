// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.market.Market;

class Admin extends MttWidget<MarketImpl> {

    public function new (mttfile = "beluga_market_admin.mtt") {
        super(Market, mttfile);
    }

    override private function getContext(): Dynamic {
        return {};
    }
}