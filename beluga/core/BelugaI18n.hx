package beluga.core;

import beluga.core.macro.JsonTool;
import haxe.macro.Context;
import beluga.tool.DynamicTool;
import haxe.macro.Expr;
import haxe.Template;
import haxe.macro.Context;

class UnknowLangException extends BelugaException
{
    public var lang(default, null) : String;

    public function new(lang : String) {
        super("The language " + lang + "is not supported by Beluga");
        this.lang = lang;
    }
}

class BelugaI18n
{

    public static var supportedLangList(default, null) : Array<String> = [
        "fr_FR",
        "en_US"
    ];

    public static var curLang(default, set) : String = "fr_FR";

    private static function set_curLang(lang : String) {
        if (Lambda.has(supportedLangList, lang)) {
            curLang = lang;
        } else {
            throw new UnknowLangException(lang);
        }
        return lang;
    }

    public static function getKey(i18n, key : String, ?ctx : Dynamic) {
        var f = Reflect.field;
        var textMap = f(i18n, curLang);
        if (textMap != null) {
            var textValue = f(textMap, key);
            if (textValue != null) {
                if (ctx == null) {
                    return textValue;
                } else {
                    var tpl = new Template(textValue);
                    return tpl.execute(ctx);
                }
            } else {
                return "key " + key + " does not exist for lang " + curLang;
            }
        } else {
            return "Language " + curLang + " is not supported";
        }
    }

    macro public static function loadI18nFolder(folderPath : String, ?parent : Expr ) {
        var i18n = { };

        for (lang in supportedLangList) {
            try { // try to find the local
                Reflect.setField(i18n, lang, JsonTool.load(folderPath + lang + ".json"));
            } catch (e: JsonToolException) {
                switch (e.error_kind) {
                    case JTFileNotFoundException(_): {
                        // nothing to do
                        // Beluga accept the list BelugaI18n::supportedLangList of language
                        // but the user don't need to provide each of them
                    }
                    case JTParseError(s): {
                        throw new Error("invalid json file: " + folderPath + lang + " " + s, Context.currentPos());
                    }
                }
            }
        }
        var expr = Context.makeExpr(i18n, Context.currentPos());
        if (parent == null) {
            return expr;
        } else {
            return macro BelugaI18n.concat($ { parent }, $ { expr } );
        }
    }


    public static function concatArray(i : Array<Dynamic>) {
        var c = { };
        for (j in i) {
            for (lang in supportedLangList) {
                Reflect.setField(c, lang, DynamicTool.concat(Reflect.field(c, lang), Reflect.field(j, lang)));
            }
        }
        return c;
    }

    public static function concat(a : Dynamic, b : Dynamic) {
        var c = { };
        for (lang in supportedLangList) {
            Reflect.setField(c, lang, DynamicTool.concat(Reflect.field(a, lang), Reflect.field(b, lang)));
        }
        return c;
    }
}