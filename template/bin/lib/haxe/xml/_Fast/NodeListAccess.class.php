<?php

class haxe_xml__Fast_NodeListAccess {
	public function __construct($x) {
		if(!php_Boot::$skip_constructor) {
		$this->__x = $x;
	}}
	public $__x;
	public function resolve($name) {
		$l = new HList();
		if(null == $this->__x) throw new HException('null iterable');
		$__hx__it = $this->__x->elementsNamed($name);
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			$l->add(new haxe_xml_Fast($x));
		}
		return $l;
	}
	public $__dynamics = array();
	public function __get($n) {
		if(isset($this->__dynamics[$n]))
			return $this->__dynamics[$n];
	}
	public function __set($n, $v) {
		$this->__dynamics[$n] = $v;
	}
	public function __call($n, $a) {
		if(isset($this->__dynamics[$n]) && is_callable($this->__dynamics[$n]))
			return call_user_func_array($this->__dynamics[$n], $a);
		if('toString' == $n)
			return $this->__toString();
		throw new HException("Unable to call <".$n.">");
	}
	function __toString() { return 'haxe.xml._Fast.NodeListAccess'; }
}
