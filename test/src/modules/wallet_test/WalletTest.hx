package modules.wallet_test;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.wallet.Wallet;
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

class WalletTest implements MetadataReader {
    public var beluga(default, null) : Beluga;
    public var wallet(default, null) : Wallet;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.wallet = beluga.getModuleInstance(Wallet);
    }

    @bTrigger("beluga_wallet_create_currency_success",
              "beluga_wallet_create_currency_fail",
              "beluga_wallet_remove_currency_success",
              "beluga_wallet_remove_currency_fail",
              "beluga_wallet_set_site_currency_fail",
              "beluga_wallet_set_site_currency_success",
              "beluga_wallet_create_success",
              "beluga_wallet_create_fail")
    public static function _doTestPage() {
       new WalletTest(Beluga.getInstance()).doTestPage();
    }

    public function doTestPage() {
        var walletWidget = this.wallet.getWidget("display");
        walletWidget.context = this.wallet.getDisplayContext();
        var walletAdminWidget = this.wallet.getWidget("admin");
        walletAdminWidget.context = this.wallet.getDisplayAdminContext();
        var has_wallet = if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            1;
        } else {
            0;
        };

        var html = Renderer.renderDefault("page_wallet_widget", "Your wallet", {
            walletWidget: walletWidget.render(),
            walletAdminWidget: walletAdminWidget.render(),
            has_wallet: has_wallet,
            site_currency: this.wallet.getSiteCurrencyOrDefault().cu_name
        });
        Sys.print(html);
    }

    public function doBuyCurrency() {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.wallet.addRealFunds(Beluga.getInstance().getModuleInstance(Account).loggedUser, 10.);
        }

        this.doTestPage();
    }

    public function doDefault(d : Dispatch) {
        Web.setHeader("Content-Type", "text/plain");
        Sys.println("No action available for: " + d.parts[0]);
        Sys.println("Available actions are:");
        Sys.println("TestPage");
    }
}