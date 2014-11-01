// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

import beluga.module.market.widget.Display;
import beluga.module.market.widget.Cart;
import beluga.module.market.widget.Admin;

class MarketWidget {
    public var cart = new Cart();
    public var display = new Display();
    public var admin = new Admin();

    public function new() {}
}