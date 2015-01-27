// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

import beluga.trigger.Trigger;
import beluga.trigger.TriggerVoid;
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
    public var addNewProductFail = new Trigger<{error: MarketErrorKind}>();
    public var addNewProductSuccess = new Trigger<{product: Product}>();
    public var deleteProductFail = new Trigger<{error: MarketErrorKind}>();
    public var deleteProductSuccess = new Trigger<{product: Product}>();
    public var updateProductFail = new Trigger<{error: MarketErrorKind}>();
    public var updateProductSuccess = new Trigger<{product: Product}>();
    public var showUpdateProductFail = new Trigger<{error: MarketErrorKind}>();
    public var showUpdateProductSuccess = new Trigger<{product: Product}>();

    public function new() {}
}