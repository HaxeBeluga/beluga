// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.market_test;

// Beluga
import beluga.Beluga;
import beluga.module.market.Market;
import beluga.module.account.Account;
import beluga.module.market.MarketErrorKind;
import beluga.module.market.model.Product;

// BelugaTest
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class MarketTest {
    public var beluga(default, null) : Beluga;
    public var market(default, null) : Market;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.market = beluga.getModuleInstance(Market);
        this.market.triggers.addProductSuccess.add(this.doAddProductSuccess);
        this.market.triggers.addProductFail.add(this.doAddProductFail);
        this.market.triggers.removeProductSuccess.add(this.doCartPage);
        // this.market.triggers.removeProductFail.add(this.doCartPage);
        this.market.triggers.checkoutCartSuccess.add(this.doCartPage);
        this.market.triggers.checkoutCartFail.add(this.doCheckoutCartFail);
    }

    public function doTestPage() {
        var html = Renderer.renderDefault("page_market_widget", "The market", {
            marketWidget: market.widgets.display.render()
        });
        Sys.print(html);
    }

    public function doAddProductSuccess(args: {product: Product}) {
        this.doTestPage();
    }

    public function doAddProductFail(args: {error: MarketErrorKind}) {
        this.doTestPage();
    }

    public function doCheckoutCartFail(args: {error: MarketErrorKind}) {
        this.doCartPage();
    }

    public function doAdminPage() {
        var html = Renderer.renderDefault("page_market_admin_widget", "Market administration", {
            marketAdminWidget: market.widgets.admin.render()
        });
        Sys.print(html);
    }

    public function doCartPage() {
        var html = Renderer.renderDefault("page_market_admin_widget", "User Cart", {
            marketAdminWidget: market.widgets.cart.render(),
        });
        Sys.print(html);
    }

    public function doDefault(d : Dispatch) {
        Web.setHeader("Content-Type", "text/plain");
        Sys.println("No action available for: " + d.parts[0]);
        Sys.println("Available actions are:");
        Sys.println("TestPage");
    }
}