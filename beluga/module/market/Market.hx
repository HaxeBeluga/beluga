package beluga.module.market;

// beluga core
import beluga.core.module.Module;

// beluga mods

// haxe
import haxe.ds.Option;

interface Market extends Module {
    // widget functions
    public function display(): Void;
    public function admin(): Void;

    // widget context functions
    public function getDisplayContext(): Dynamic;
    public function getAdminContext(): Dynamic;
}