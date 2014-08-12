<?php

class HList implements IteratorAggregate{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->length = 0;
	}}
	public $h;
	public $q;
	public $length;
	public function add($item) {
		$x = array($item, null);
		if($this->h === null) {
			$this->h =& $x;
		} else {
			$this->q[1] =& $x;
		}
		$this->q =& $x;
		$this->length++;
	}
	public function push($item) {
		$x = array($item, &$this->h);
		$this->h =& $x;
		if($this->q === null) {
			$this->q =& $x;
		}
		$this->length++;
	}
	public function first() {
		if($this->h === null) {
			return null;
		} else {
			return $this->h[0];
		}
	}
	public function pop() {
		if($this->h === null) {
			return null;
		}
		$x = $this->h[0];
		$this->h = $this->h[1];
		if($this->h === null) {
			$this->q = null;
		}
		$this->length--;
		return $x;
	}
	public function isEmpty() {
		return $this->h === null;
	}
	public function iterator() {
		return new _hx_list_iterator($this);
	}
	public function join($sep) {
		$s = "";
		$first = true;
		$l = $this->h;
		while($l !== null) {
			if($first) {
				$first = false;
			} else {
				$s .= _hx_string_or_null($sep);
			}
			$s .= Std::string($l[0]);
			$l = $l[1];
		}
		return $s;
	}
	public function getIterator() {
		return $this->iterator();
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
	function __toString() { return 'List'; }
}
