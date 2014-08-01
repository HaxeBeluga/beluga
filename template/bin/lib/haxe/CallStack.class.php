<?php

class haxe_CallStack {
	public function __construct(){}
	static function callStack() {
		return haxe_CallStack::makeStack("%s");
	}
	static function makeStack($s) {
		if(!isset($GLOBALS[$s])) {
			return (new _hx_array(array()));
		}
		$a = $GLOBALS[$s];
		$m = (new _hx_array(array()));
		{
			$_g1 = 0;
			$_g = null;
			$_g = $a->length - ((($s === "%s") ? 2 : 0));
			while($_g1 < $_g) {
				$i = $_g1++;
				$d = _hx_explode("::", $a[$i]);
				$m->unshift(haxe_StackItem::Method($d[0], $d[1]));
				unset($i,$d);
			}
		}
		return $m;
	}
	function __toString() { return 'haxe.CallStack'; }
}
