<?php

class beluga_core_BelugaException {
	public function __construct($msg) {
		if(!php_Boot::$skip_constructor) {
		$this->message = $msg;
	}}
	public $message;
	public function toString() {
		{
			$_g = 0;
			$_g1 = haxe_CallStack::callStack();
			while($_g < $_g1->length) {
				$it = $_g1[$_g];
				++$_g;
				switch($it->index) {
				case 2:{
					$line = $it->params[2];
					$file = $it->params[1];
					$s = $it->params[0];
					return $this->message;
				}break;
				default:{
				}break;
				}
				unset($it);
			}
		}
		return $this->message;
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
	function __toString() { return $this->toString(); }
}
