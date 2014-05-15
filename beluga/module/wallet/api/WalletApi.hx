package beluga.module.wallet.api;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.wallet.Wallet;

// Haxe
import haxe.web.Dispatch;

class WalletApi {
    var beluga : Beluga;
    var wallet : Wallet;

    public function new(beluga: Beluga, wallet: Wallet) {
        this.beluga = beluga;
        this.wallet = wallet;
    }

    public function doCreate(): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_create", []);
    }

    public function doDisplay(): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_display", []);
    }

    public function doAdmin(): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_display_admin", []);
    }


    public function doCreateCurrency(args: { name: String, rate: String }): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_create_currency", [args]);

    }

    public function doRemoveCurrency(args: { id: Int }): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_remove_currency", [args]);

    }

    public function doSetSiteCurrency(args: {id: Int }): Void {
        beluga.triggerDispatcher.dispatch("beluga_wallet_set_site_currency", [args]);
    }

    public function doDefault(): Void {
        trace("Wallet default page");
    }
}