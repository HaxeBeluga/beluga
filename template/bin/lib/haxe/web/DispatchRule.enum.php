<?php

class haxe_web_DispatchRule extends Enum {
	public static function DRArgs($r, $args, $opt) { return new haxe_web_DispatchRule("DRArgs", 2, array($r, $args, $opt)); }
	public static function DRMatch($r) { return new haxe_web_DispatchRule("DRMatch", 0, array($r)); }
	public static function DRMeta($r) { return new haxe_web_DispatchRule("DRMeta", 3, array($r)); }
	public static function DRMult($r) { return new haxe_web_DispatchRule("DRMult", 1, array($r)); }
	public static $__constructors = array(2 => 'DRArgs', 0 => 'DRMatch', 3 => 'DRMeta', 1 => 'DRMult');
	}
