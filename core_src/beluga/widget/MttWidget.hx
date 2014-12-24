// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// beluga.widget.MttWidget Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.widget ;

import haxe.Template;
import haxe.Resource;
import beluga.widget.MttWidget;
import beluga.module.Module;
import beluga.Beluga;
import beluga.ConfigLoader;
import beluga.I18n;
import beluga.tool.DynamicTool;

class MttWidget<ModuleType: Module> implements Widget {
    public var mod: ModuleType;
    public var i18n : Dynamic;
    public static var bootstrap = Layout.newFromPath("/beluga/widget/layout/bootstrap.mtt");

    private static var id = 0;
    private var layout : Layout;

    public function new(clazz : Class<ModuleType>, layout : Layout) {
        this.layout = layout;
        this.mod = cast Beluga.getInstance().getModuleInstance(clazz);
    }

    public function render() : String {
        return layout.execute( getContextIntern(), getMacro());
    }

    inline private function getContextIntern() {
        var context = getContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }

    private function getContext(): Dynamic {
        return { };
    }

    private function getMacro() {
        var m = {
            i18n: MttWidget.getI18nKey.bind(_, i18n, _, getContextIntern()),
            str: safeGetStr
        };
        return m;
    }

    private static function safeGetStr(resolve : String -> Dynamic, str : String) {
        var attrList = str.split(".");
        var o = resolve(attrList.shift());
        return switch(DynamicTool.getFieldArray(o, attrList)) {
            case None: "";
            case Some(o): Std.string(o);
        }
    }

    private static function getI18nKey(resolve : String -> Dynamic, obj:Dynamic, key : String, ?ctx : Dynamic) {
        return BelugaI18n.getKey(obj, key, ctx);
    }

}