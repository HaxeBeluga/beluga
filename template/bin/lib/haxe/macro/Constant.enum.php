<?php

class haxe_macro_Constant extends Enum {
	public static function CFloat($f) { return new haxe_macro_Constant("CFloat", 1, array($f)); }
	public static function CIdent($s) { return new haxe_macro_Constant("CIdent", 3, array($s)); }
	public static function CInt($v) { return new haxe_macro_Constant("CInt", 0, array($v)); }
	public static function CRegexp($r, $opt) { return new haxe_macro_Constant("CRegexp", 4, array($r, $opt)); }
	public static function CString($s) { return new haxe_macro_Constant("CString", 2, array($s)); }
	public static $__constructors = array(1 => 'CFloat', 3 => 'CIdent', 0 => 'CInt', 4 => 'CRegexp', 2 => 'CString');
	}
