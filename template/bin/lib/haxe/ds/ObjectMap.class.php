<?php

class haxe_ds_ObjectMap implements IMap{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->h = array();
		$this->hk = array();
	}}
	public $h;
	public $hk;
	public function set($key, $value) {
		$id = haxe_ds_ObjectMap::getId($key);
		$this->h[$id] = $value;
		$this->hk[$id] = $key;
	}
	public function get($key) {
		$id = haxe_ds_ObjectMap::getId($key);
		if(array_key_exists($id, $this->h)) {
			return $this->h[$id];
		} else {
			return null;
		}
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
	static function getId($key) {
		return spl_object_hash($key);
	}
	function __toString() { return 'haxe.ds.ObjectMap'; }
}
