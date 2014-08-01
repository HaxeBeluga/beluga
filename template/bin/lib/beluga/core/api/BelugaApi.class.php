<?php

class beluga_core_api_BelugaApi implements beluga_core_api_IAPI{
	public function __construct() {
		;
	}
	public $beluga;
	public $module;
	public function handleSessionPath() {
	}
	public function doDefault($d) {
		Sys::hprint("Welcome !");
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	function __toString() { return 'beluga.core.api.BelugaApi'; }
}
beluga_core_api_BelugaApi::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("dispatchConfig" => (new _hx_array(array("oy7:defaultjy21:haxe.web.DispatchRule:0:1jy18:haxe.web.MatchRule:5:0g")))))));
