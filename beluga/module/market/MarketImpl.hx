package beluga.module.market;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods

// Haxe
import haxe.xml.Fast;
import haxe.ds.Option;

class MarketImpl extends ModuleImpl implements MarketInternal {

    public function new() { super(); }
    override public function loadConfig(data : Fast): Void {}

    // widget functions

    public function _display(): Void {
        Beluga.getInstance().getModuleInstance(Market).display();
    }

    public function display(): Void {}

    public function _admin(): Void {
        Beluga.getInstance().getModuleInstance(Market).admin();
    }

    public function admin(): Void {}

    // widget context functions
    public function getDisplayContext(): Dynamic {
        return {};
    }

    public function getAdminContext(): Dynamic {
        return {};
    }
}