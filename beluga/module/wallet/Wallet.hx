package beluga.module.wallet;

import beluga.core.module.Module;

/**
 * Description of the Wallet
 *
 * @author Jeremy
 */
interface Wallet extends Module {
    public function getDisplayWalletContext(): Dynamic;
    public function getDisplayWalletAdminContext(): Dynamic;
}