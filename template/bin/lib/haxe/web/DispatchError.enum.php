<?php

class haxe_web_DispatchError extends Enum {
	public static $DEInvalidValue;
	public static $DEMissing;
	public static function DEMissingParam($p) { return new haxe_web_DispatchError("DEMissingParam", 3, array($p)); }
	public static function DENotFound($part) { return new haxe_web_DispatchError("DENotFound", 0, array($part)); }
	public static $DETooManyValues;
	public static $__constructors = array(1 => 'DEInvalidValue', 2 => 'DEMissing', 3 => 'DEMissingParam', 0 => 'DENotFound', 4 => 'DETooManyValues');
	}
haxe_web_DispatchError::$DEInvalidValue = new haxe_web_DispatchError("DEInvalidValue", 1);
haxe_web_DispatchError::$DEMissing = new haxe_web_DispatchError("DEMissing", 2);
haxe_web_DispatchError::$DETooManyValues = new haxe_web_DispatchError("DETooManyValues", 4);
