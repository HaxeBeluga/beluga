<?php

class beluga_core_macro_tool_ExprUtils {
	public function __construct(){}
	static function concat($beg_expr, $end_expr) {
		if($beg_expr !== null) {
			return _hx_anonymous(array("expr" => haxe_macro_ExprDef::EBlock((new _hx_array(array($beg_expr, $end_expr)))), "pos" => _hx_anonymous(array("file" => "/home/imperio/haxe/Beluga/beluga/core/macro_tool/ExprUtils.hx", "min" => 253, "max" => 278))));
		} else {
			return $end_expr;
		}
	}
	function __toString() { return 'beluga.core.macro_tool.ExprUtils'; }
}
