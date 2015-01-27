// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.Beluga;
import beluga.BelugaException;

// Beluga mods
import beluga.module.market.Market;

class MarketApi {
    public var beluga : Beluga;
    public var module : Market;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doDisplay(): Void {
        module.display();
    }

    public function doAdmin(): Void {
        module.admin();
    }

    public function doCart(): Void {
        module.cart();
    }

    public function doShowUpdateProduct(args: {id: Int}): Void {
        module.showUpdateProduct(args);
    }

    public function doDeleteProduct(args: { id: Int }): Void {
        module.deleteProduct(args);
    }

    public function doUpdateProduct(args: { name: String, price: Int, stock: Int, desc: String, image: String, id: Int }): Void {
        module.updateProduct(args);
    }

    public function doAddProduct(args: { name: String, price: Int, stock: Int, desc: String, image: String }): Void {
        module.addProduct(args);
    }

    public function doAddProductToCart(args: { id: Int }): Void {
        module.addProductToCart(args);
    }

    public function doRemoveProductInCart(args: { id: Int }): Void {
        module.removeProductInCart(args);
    }

    public function doCheckoutCart(): Void {
        module.checkoutCart();
    }

    public function doDefault(): Void {
        trace("Market default page");
    }
}