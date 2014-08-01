<?php

class Main {
	public function __construct(){}
	static $beluga;
	static function main() {
		Main::$beluga = beluga_core_Beluga::getInstance();
		_hx_deref(new haxe_web_Dispatch(php_Web::getParamsString(), php_Web::getParams()))->runtimeDispatch(haxe_web_Dispatch::extractConfig(Main::$beluga->api));
	}
	function __toString() { return 'Main'; }
}
