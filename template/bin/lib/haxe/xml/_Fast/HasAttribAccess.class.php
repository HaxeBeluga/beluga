<?php

class haxe_xml__Fast_HasAttribAccess {
	public function __construct($x) {
		if(!php_Boot::$skip_constructor) {
		$this->__x = $x;
	}}
	public $__x;
	public function resolve($name) {
		if((is_object($_t = $this->__x->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$Document : $_t == Xml::$Document)) {
			throw new HException("Cannot access document attribute " . _hx_string_or_null($name));
		}
		return $this->__x->exists($name);
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
	function __toString() { return 'haxe.xml._Fast.HasAttribAccess'; }
}
