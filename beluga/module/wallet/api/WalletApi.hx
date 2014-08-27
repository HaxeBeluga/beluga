package beluga.module.wallet.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;

// Beluga mods
import beluga.module.wallet.Wallet;

class WalletApi {
    public var beluga : Beluga;
    public var module : Wallet;

    public function new() {}

    public function doCreate(): Void {
        module.create();
    }

    public function doDisplay(): Void {
        module.display();
    }

    public function doAdmin(): Void {
        module.admin();
    }


    public function doCreateCurrency(args: { name: String, rate: String }): Void {
        module.createCurrency(args);
    }

    public function doRemoveCurrency(args: { id: Int }): Void {
        module.removeCurrency(args);
    }

    public function doSetSiteCurrency(args: {id: Int }): Void {
        module.setSiteCurrency(args);
    }

    public function doDefault(): Void {
        trace("Wallet default page");
    }
}