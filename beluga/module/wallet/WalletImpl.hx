package beluga.module.wallet;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
// import beluga.module.account.model.User;


// Haxe
import haxe.xml.Fast;

/**
 * Implementation of the Wallet.
 *
 * @author Valentin & Jeremy
 */
class WalletImpl extends ModuleImpl implements WalletInternal {

    public function new() {
        super();
    }

    override public function loadConfig(data : Fast): Void {

    }

    public function getDisplayWalletContext(): Dynamic {
        return {};
    }

    public function getDisplayWalletAdminContext(): Dynamic {
        return {};
    }
}