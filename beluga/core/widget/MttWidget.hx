package beluga.core.widget;

import haxe.Template;
import haxe.Resource;

/**
 * ...
 * @author brissa_A
 */
class MttWidget implements Widget
{

    private static var id = 0;
    private var template : Template;

    public function new(mttfile : String)
    {
        var templateFileContent = Resource.getString(mttfile);
        template = new haxe.Template(templateFileContent);
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
        return {};
    }

}