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

    public function doDefault(): Void {
        trace("Wallet default page");
    }

    public function doCss(d: Dispatch): Void {
        // d.dispatch(new CssApi());
    }
}