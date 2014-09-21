package beluga.core.widget;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.core.module.Module;

import haxe.Template;
import haxe.Resource;

class MttWidget<WImpl: ModuleImpl> implements Widget {
    public var mod: WImpl;
    public var i18n : Dynamic;

    private static var id = 0;
    private var template : Template;

    public function new<T: Module>(clazz : Class<T>, mttfile : String) {
        var templateFileContent = Resource.getString(mttfile);
        this.template = new haxe.Template(templateFileContent);
        this.mod = cast Beluga.getInstance().getModuleInstance(clazz);
    }

    public function render() : String {
        return template.execute( getContext(), getMacro());
    }

    private static function getI18nKey(resolve : String -> Dynamic, obj:Dynamic, key : String, ?ctx : Dynamic) {
        return BelugaI18n.getKey(obj, key, ctx);
    }

    private function getContext() {
        return { };
    }

    private function getMacro() {
        var m = {
            i18n: MttWidget.getI18nKey.bind(_, i18n, _, getContext())
        };
        return m;
    }

}