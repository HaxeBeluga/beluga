<?php

class haxe_rtti_Meta {
	public function __construct(){}
	static function getType($t) {
		$meta = $t->__meta__;
		if($meta === null || _hx_field($meta, "obj") === null) {
			return _hx_anonymous(array());
		} else {
			return $meta->obj;
		}
	}
	static function getFields($t) {
		$meta = $t->__meta__;
		if($meta === null || _hx_field($meta, "fields") === null) {
			return _hx_anonymous(array());
		} else {
			return $meta->fields;
		}
	}
	function __toString() { return 'haxe.rtti.Meta'; }
}
