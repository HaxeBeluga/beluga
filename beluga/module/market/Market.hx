// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

// beluga core
import beluga.core.module.Module;

// beluga mods
import beluga.module.market.model.Product;
import beluga.module.market.MarketWidget;

// haxe
import haxe.ds.Option;

interface Market extends Module {
    public var triggers: MarketTrigger;
    public var widgets: MarketWidget;

    // widget functions
    public function display(): Void;
    public function admin(): Void;
    public function cart(): Void;
    public function addProductToCart(args: { id: Int }): Void;
    public function removeProductInCart(args: { id: Int }): Void;
    public function checkoutCart(): Void;

    // widget context functions
    public function getDisplayContext(): Dynamic;
    public function getAdminContext(): Dynamic;
    public function getCartContext(): Dynamic;

    public function getProductList(): List<Dynamic>;
    public function getProductFromId(id: Int): Option<Product>;
}