package modules.market_test;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.market.Market;
import beluga.module.account.Account;

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

class MarketTest implements MetadataReader {
    public var beluga(default, null) : Beluga;
    public var market(default, null) : Market;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.market = beluga.getModuleInstance(Market);
        this.market.triggers.addProductSuccess.add(this.doTestPage);
        this.market.triggers.addProductFail.add(this.doTestPage);
        this.market.triggers.removeProductSuccess.add(this.doCartPage);
        this.market.triggers.removeProductSuccess.add(this.doCartPage);
        this.market.triggers.checkoutCartSuccess.add(this.doCartPage);
        this.market.triggers.checkoutCartFail.add(this.doCartPage);
    }

    public function doTestPage() {
        var marketWidget = this.market.getWidget("display");
        marketWidget.context = this.market.getDisplayContext();

        var html = Renderer.renderDefault("page_market_widget", "The market", {
            marketWidget: marketWidget.render(),
        });
        Sys.print(html);
    }

    public function doAdminPage() {
        var marketAdminWidget = this.market.getWidget("admin");
        marketAdminWidget.context = this.market.getAdminContext();

        var html = Renderer.renderDefault("page_market_admin_widget", "Market administration", {
            marketAdminWidget: marketAdminWidget.render(),
        });
        Sys.print(html);
    }

    public function doCartPage() {
        var marketCartWidget = this.market.getWidget("cart");
        marketCartWidget.context = this.market.getCartContext();

        var html = Renderer.renderDefault("page_market_admin_widget", "User Cart", {
            marketAdminWidget: marketCartWidget.render(),
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