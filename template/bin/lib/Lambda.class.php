<?php

class Lambda {
	public function __construct(){}
	static function map($it, $f) {
		$l = new HList();
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			$l->add(call_user_func_array($f, array($x)));
		}
		return $l;
	}
	static function has($it, $elt) {
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			if((is_object($_t = $x) && !($_t instanceof Enum) ? $_t === $elt : $_t == $elt)) {
				return true;
			}
			unset($_t);
		}
		return false;
	}
	static function filter($it, $f) {
		$l = new HList();
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			if(call_user_func_array($f, array($x))) {
				$l->add($x);
			}
		}
		return $l;
	}
	function __toString() { return 'Lambda'; }
}
