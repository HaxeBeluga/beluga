<?php

class tink_macro_Metadatas {
	public function __construct(){}
	static function toMap($m) {
		$ret = new haxe_ds_StringMap();
		if($m !== null) {
			$_g = 0;
			while($_g < $m->length) {
				$meta = $m[$_g];
				++$_g;
				if(!$ret->exists($meta->name)) {
					$ret->set($meta->name, (new _hx_array(array())));
				}
				$ret->get($meta->name)->push($meta->params);
				unset($meta);
			}
		}
		return $ret;
	}
	static function getValues($m, $name) {
		if($m === null) {
			return (new _hx_array(array()));
		} else {
			$_g = (new _hx_array(array()));
			{
				$_g1 = 0;
				while($_g1 < $m->length) {
					$meta = $m[$_g1];
					++$_g1;
					if($meta->name === $name) {
						$_g->push($meta->params);
					}
					unset($meta);
				}
			}
			return $_g;
		}
	}
	function __toString() { return 'tink.macro.Metadatas'; }
}
