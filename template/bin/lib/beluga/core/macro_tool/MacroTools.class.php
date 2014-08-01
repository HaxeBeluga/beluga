<?php

class beluga_core_macro_tool_MacroTools {
	public function __construct(){}
	static function fullClassPath($classType) {
		return _hx_string_or_null((beluga_core_macro_tool_MacroTools_0($classType))) . _hx_string_or_null($classType->name);
	}
	function __toString() { return 'beluga.core.macro_tool.MacroTools'; }
}
function beluga_core_macro_tool_MacroTools_0(&$classType) {
	if($classType->pack->length > 0) {
		return _hx_string_or_null($classType->pack->join(".")) . ".";
	} else {
		return "";
	}
}
