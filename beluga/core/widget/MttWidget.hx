// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.widget;

import haxe.Template;
import haxe.Resource;
import haxe.ds.Option;

import beluga.core.Beluga;
import beluga.core.module.Module;
import beluga.core.module.Module;
import beluga.core.macro.ConfigLoader;
import beluga.tool.DynamicTool;

class MttWidget<ModuleType: Module> implements Widget {
    public var mod: ModuleType;
    public var i18n : Dynamic;

    private static var id = 0;
    private var template : Template;

    public function new(templateFileContent : String) {
        this.template = new haxe.Template(templateFileContent);
        this.mod = cast Beluga.getInstance().getModuleInstance(Type.getClass(mod));
    }


    public function render() : String {
        return template.execute( getContextIntern(), getMacro());
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