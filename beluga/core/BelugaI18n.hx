package beluga.core;

import beluga.core.macro.JsonTool;
import haxe.macro.Context;

/**
 * ...
 * @author Alexis Brissard
 */
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
		"fr",
		"en_US"
	];
	
	public static var curLang(default, set) : String = "fr";
	
	private static function set_curLang(lang : String) {
		if (Lambda.has(supportedLangList, lang)) {
			curLang = lang;
		} else {
			throw new UnknowLangException(lang);
		}
		return lang;
	}
	
	public static function getKey(i18n, key : String) {
		var f = Reflect.field;
		var textMap = f(i18n, curLang);
		if (textMap != null) {
			var textValue = f(textMap, key);
			if (textValue != null) {
				return textValue;
			} else {
				return "key " + key + " does not exist for lang " + curLang;
			}
		} else {
			return "Language " + curLang + " is not supported";
		}
	}
	
	macro public static function loadI18nFolder(folderPath : String) {
		var i18n = { };
		for (lang in supportedLangList) {
			Reflect.setField(i18n, lang, JsonTool.load(folderPath + lang + ".json"));
		}
		return Context.makeExpr(i18n, Context.currentPos());
	}
	
	
}