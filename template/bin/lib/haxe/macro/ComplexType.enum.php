<?php

class haxe_macro_ComplexType extends Enum {
	public static function TAnonymous($fields) { return new haxe_macro_ComplexType("TAnonymous", 2, array($fields)); }
	public static function TExtend($p, $fields) { return new haxe_macro_ComplexType("TExtend", 4, array($p, $fields)); }
	public static function TFunction($args, $ret) { return new haxe_macro_ComplexType("TFunction", 1, array($args, $ret)); }
	public static function TOptional($t) { return new haxe_macro_ComplexType("TOptional", 5, array($t)); }
	public static function TParent($t) { return new haxe_macro_ComplexType("TParent", 3, array($t)); }
	public static function TPath($p) { return new haxe_macro_ComplexType("TPath", 0, array($p)); }
	public static $__constructors = array(2 => 'TAnonymous', 4 => 'TExtend', 1 => 'TFunction', 5 => 'TOptional', 3 => 'TParent', 0 => 'TPath');
	}
