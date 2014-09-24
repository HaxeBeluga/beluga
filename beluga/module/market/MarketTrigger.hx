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

import sys.db.Types;

class MarketTrigger {
    public var addProductSuccess = new TriggerVoid();
    public var addProductFail = new TriggerVoid();
    public var removeProductSuccess = new TriggerVoid();
    public var removeProductFail = new TriggerVoid();
    public var checkoutCartSuccess = new TriggerVoid();
    public var checkoutCartFail = new TriggerVoid();

    public function new() {}
}