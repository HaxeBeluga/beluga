<?php

class beluga_core_macro_ModuleLoader {
	public function __construct(){}
	static function getModuleInstanceByName($name, $key = null) {
		if($key === null) {
			$key = "";
		}
		$realClass = Type::resolveClass(_hx_string_or_null($name) . "Impl");
		if($realClass === null) {
			$realClass = Type::resolveClass("beluga.module." . _hx_string_or_null(strtolower($name)) . "." . _hx_string_or_null(strtoupper(_hx_substr($name, 0, 1))) . _hx_string_or_null(strtolower(_hx_substr($name, 1, null))) . "Impl");
		}
		if($realClass === null) {
			throw new HException(new beluga_core_BelugaException("Module not found " . _hx_string_or_null($name)));
		}
		return call_user_func_array(Reflect::field($realClass, "getInstance"), array($key));
	}
	static function resolveModel($module, $name) {
		$realClass = Type::resolveClass("beluga.module." . _hx_string_or_null($module) . ".model." . _hx_string_or_null($name));
		if($realClass === null) {
			throw new HException(new beluga_core_BelugaException("Model not found " . _hx_string_or_null($name)));
		}
		return $realClass;
	}
	function __toString() { return 'beluga.core.macro.ModuleLoader'; }
}
