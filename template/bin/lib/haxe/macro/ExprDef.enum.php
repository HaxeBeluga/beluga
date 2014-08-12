<?php

class haxe_macro_ExprDef extends Enum {
	public static function EArray($e1, $e2) { return new haxe_macro_ExprDef("EArray", 1, array($e1, $e2)); }
	public static function EArrayDecl($values) { return new haxe_macro_ExprDef("EArrayDecl", 6, array($values)); }
	public static function EBinop($op, $e1, $e2) { return new haxe_macro_ExprDef("EBinop", 2, array($op, $e1, $e2)); }
	public static function EBlock($exprs) { return new haxe_macro_ExprDef("EBlock", 12, array($exprs)); }
	public static $EBreak;
	public static function ECall($e, $params) { return new haxe_macro_ExprDef("ECall", 7, array($e, $params)); }
	public static function ECast($e, $t) { return new haxe_macro_ExprDef("ECast", 24, array($e, $t)); }
	public static function ECheckType($e, $t) { return new haxe_macro_ExprDef("ECheckType", 28, array($e, $t)); }
	public static function EConst($c) { return new haxe_macro_ExprDef("EConst", 0, array($c)); }
	public static $EContinue;
	public static function EDisplay($e, $isCall) { return new haxe_macro_ExprDef("EDisplay", 25, array($e, $isCall)); }
	public static function EDisplayNew($t) { return new haxe_macro_ExprDef("EDisplayNew", 26, array($t)); }
	public static function EField($e, $field) { return new haxe_macro_ExprDef("EField", 3, array($e, $field)); }
	public static function EFor($it, $expr) { return new haxe_macro_ExprDef("EFor", 13, array($it, $expr)); }
	public static function EFunction($name, $f) { return new haxe_macro_ExprDef("EFunction", 11, array($name, $f)); }
	public static function EIf($econd, $eif, $eelse) { return new haxe_macro_ExprDef("EIf", 15, array($econd, $eif, $eelse)); }
	public static function EIn($e1, $e2) { return new haxe_macro_ExprDef("EIn", 14, array($e1, $e2)); }
	public static function EMeta($s, $e) { return new haxe_macro_ExprDef("EMeta", 29, array($s, $e)); }
	public static function ENew($t, $params) { return new haxe_macro_ExprDef("ENew", 8, array($t, $params)); }
	public static function EObjectDecl($fields) { return new haxe_macro_ExprDef("EObjectDecl", 5, array($fields)); }
	public static function EParenthesis($e) { return new haxe_macro_ExprDef("EParenthesis", 4, array($e)); }
	public static function EReturn($e = null) { return new haxe_macro_ExprDef("EReturn", 19, array($e)); }
	public static function ESwitch($e, $cases, $edef) { return new haxe_macro_ExprDef("ESwitch", 17, array($e, $cases, $edef)); }
	public static function ETernary($econd, $eif, $eelse) { return new haxe_macro_ExprDef("ETernary", 27, array($econd, $eif, $eelse)); }
	public static function EThrow($e) { return new haxe_macro_ExprDef("EThrow", 23, array($e)); }
	public static function ETry($e, $catches) { return new haxe_macro_ExprDef("ETry", 18, array($e, $catches)); }
	public static function EUnop($op, $postFix, $e) { return new haxe_macro_ExprDef("EUnop", 9, array($op, $postFix, $e)); }
	public static function EUntyped($e) { return new haxe_macro_ExprDef("EUntyped", 22, array($e)); }
	public static function EVars($vars) { return new haxe_macro_ExprDef("EVars", 10, array($vars)); }
	public static function EWhile($econd, $e, $normalWhile) { return new haxe_macro_ExprDef("EWhile", 16, array($econd, $e, $normalWhile)); }
	public static $__constructors = array(1 => 'EArray', 6 => 'EArrayDecl', 2 => 'EBinop', 12 => 'EBlock', 20 => 'EBreak', 7 => 'ECall', 24 => 'ECast', 28 => 'ECheckType', 0 => 'EConst', 21 => 'EContinue', 25 => 'EDisplay', 26 => 'EDisplayNew', 3 => 'EField', 13 => 'EFor', 11 => 'EFunction', 15 => 'EIf', 14 => 'EIn', 29 => 'EMeta', 8 => 'ENew', 5 => 'EObjectDecl', 4 => 'EParenthesis', 19 => 'EReturn', 17 => 'ESwitch', 27 => 'ETernary', 23 => 'EThrow', 18 => 'ETry', 9 => 'EUnop', 22 => 'EUntyped', 10 => 'EVars', 16 => 'EWhile');
	}
haxe_macro_ExprDef::$EBreak = new haxe_macro_ExprDef("EBreak", 20);
haxe_macro_ExprDef::$EContinue = new haxe_macro_ExprDef("EContinue", 21);
