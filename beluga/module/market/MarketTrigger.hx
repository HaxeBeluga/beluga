// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;
import beluga.module.market.MarketErrorKind;
import beluga.module.market.model.Product;

import sys.db.Types;

class MarketTrigger {
    public var addProductSuccess = new Trigger<{product: Product}>();
    public var addProductFail = new Trigger<{error: MarketErrorKind}>();
    public var removeProductSuccess = new TriggerVoid();
    public var removeProductFail = new Trigger<{error: MarketErrorKind}>();
    public var checkoutCartSuccess = new TriggerVoid();
    public var checkoutCartFail = new Trigger<{error: MarketErrorKind}>();

    public function new() {}
}