<?php

class haxe_web_MatchRule extends Enum {
	public static $MRBool;
	public static $MRDispatch;
	public static function MREnum($e) { return new haxe_web_MatchRule("MREnum", 4, array($e)); }
	public static $MRFloat;
	public static $MRInt;
	public static function MROpt($r) { return new haxe_web_MatchRule("MROpt", 7, array($r)); }
	public static function MRSpod($c, $lock) { return new haxe_web_MatchRule("MRSpod", 6, array($c, $lock)); }
	public static $MRString;
	public static $__constructors = array(1 => 'MRBool', 5 => 'MRDispatch', 4 => 'MREnum', 2 => 'MRFloat', 0 => 'MRInt', 7 => 'MROpt', 6 => 'MRSpod', 3 => 'MRString');
	}
haxe_web_MatchRule::$MRBool = new haxe_web_MatchRule("MRBool", 1);
haxe_web_MatchRule::$MRDispatch = new haxe_web_MatchRule("MRDispatch", 5);
haxe_web_MatchRule::$MRFloat = new haxe_web_MatchRule("MRFloat", 2);
haxe_web_MatchRule::$MRInt = new haxe_web_MatchRule("MRInt", 0);
haxe_web_MatchRule::$MRString = new haxe_web_MatchRule("MRString", 3);
