<?php

class beluga_core__TriggerDispatcher_CallbackTrigger {
	public function __construct($clazz, $method) {
		if(!php_Boot::$skip_constructor) {
		$this->clazz = $clazz;
		$this->method = $method;
	}}
	public $clazz;
	public $method;
	public function call($params = null) {
		if($params === null) {
			$params = new _hx_array(array());
		}
		$realClass = $this->clazz;
		if(Std::is($this->clazz, _hx_qtype("String"))) {
			$realClass = Type::resolveClass($this->clazz);
			if($realClass === null) {
				throw new HException(new beluga_core_BelugaException("Error: class \"" . Std::string($this->clazz) . "\" can't be resolved"));
			}
		}
		Reflect::callMethod($realClass, Reflect::field($realClass, $this->method), $params);
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
	function __toString() { return 'beluga.core._TriggerDispatcher.CallbackTrigger'; }
}
