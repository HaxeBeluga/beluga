<?php

class haxe__Template_TemplateExpr extends Enum {
	public static function OpBlock($l) { return new haxe__Template_TemplateExpr("OpBlock", 4, array($l)); }
	public static function OpExpr($expr) { return new haxe__Template_TemplateExpr("OpExpr", 1, array($expr)); }
	public static function OpForeach($expr, $loop) { return new haxe__Template_TemplateExpr("OpForeach", 5, array($expr, $loop)); }
	public static function OpIf($expr, $eif, $eelse) { return new haxe__Template_TemplateExpr("OpIf", 2, array($expr, $eif, $eelse)); }
	public static function OpMacro($name, $params) { return new haxe__Template_TemplateExpr("OpMacro", 6, array($name, $params)); }
	public static function OpStr($str) { return new haxe__Template_TemplateExpr("OpStr", 3, array($str)); }
	public static function OpVar($v) { return new haxe__Template_TemplateExpr("OpVar", 0, array($v)); }
	public static $__constructors = array(4 => 'OpBlock', 1 => 'OpExpr', 5 => 'OpForeach', 2 => 'OpIf', 6 => 'OpMacro', 3 => 'OpStr', 0 => 'OpVar');
	}
