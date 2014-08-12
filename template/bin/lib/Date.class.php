<?php

class Date {
	public function __construct($year, $month, $day, $hour, $min, $sec) {
		if(!php_Boot::$skip_constructor) {
		$this->__t = mktime($hour, $min, $sec, $month + 1, $day, $year);
	}}
	public $__t;
	public function toString() {
		return date("Y-m-d H:i:s", $this->__t);
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
	static function fromPhpTime($t) {
		$d = new Date(2000, 1, 1, 0, 0, 0);
		$d->__t = $t;
		return $d;
	}
	static function fromString($s) {
		return Date::fromPhpTime(strtotime($s));
	}
	function __toString() { return $this->toString(); }
}
