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

class WalletTest {
    public var beluga(default, null) : Beluga;
    public var wallet(default, null) : Wallet;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.wallet = beluga.getModuleInstance(Wallet);
        this.wallet.triggers.creationSuccess.add(this.doTestPage);
        this.wallet.triggers.creationFail.add(this.doTestPage);
        this.wallet.triggers.currencyCreationSuccess.add(this.doTestPage);
        this.wallet.triggers.currencyCreationFail.add(this.doTestPage);
        this.wallet.triggers.currencyRemoveSuccess.add(this.doTestPage);
        this.wallet.triggers.currencyRemoveFail.add(this.doTestPage);
        this.wallet.triggers.setSiteCurrencySuccess.add(this.doTestPage);
        this.wallet.triggers.setSiteCurrencyFail.add(this.doTestPage);
    }

    public function doTestPage() {
        var has_wallet =
            if (Beluga.getInstance().getModuleInstance(Account).isLogged) { 1; }
            else { 0; };
        var html = Renderer.renderDefault("page_wallet_widget", "Your wallet", {
            walletWidget: wallet.widgets.show.render(),
            walletAdminWidget: wallet.widgets.admin.render(),
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