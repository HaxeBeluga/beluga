<?php

class Type {
	public function __construct(){}
	static function getClass($o) {
		if($o === null) {
			return null;
		}
		if(is_array($o)) {
			if(count($o) === 2 && is_callable($o)) {
				return null;
			}
			return _hx_ttype("Array");
		}
		if(is_string($o)) {
			if(_hx_is_lambda($o)) {
				return null;
			}
			return _hx_ttype("String");
		}
		if(!is_object($o)) {
			return null;
		}
		$c = get_class($o);
		if($c === false || $c === "_hx_anonymous" || is_subclass_of($c, "enum")) {
			return null;
		} else {
			return _hx_ttype($c);
		}
	}
	static function getSuperClass($c) {
		$s = get_parent_class($c->__tname__);
		if($s === false) {
			return null;
		} else {
			return _hx_ttype($s);
		}
	}
	static function getClassName($c) {
		if($c === null) {
			return null;
		}
		return $c->__qname__;
	}
	static function getEnumName($e) {
		return $e->__qname__;
	}
	static function resolveClass($name) {
		$c = _hx_qtype($name);
		if($c instanceof _hx_class || $c instanceof _hx_interface) {
			return $c;
		} else {
			return null;
		}
	}
	static function resolveEnum($name) {
		$e = _hx_qtype($name);
		if($e instanceof _hx_enum) {
			return $e;
		} else {
			return null;
		}
	}
	static function createEmptyInstance($cl) {
		if($cl->__qname__ === "Array") {
			return (new _hx_array(array()));
		}
		if($cl->__qname__ === "String") {
			return "";
		}
		try {
			php_Boot::$skip_constructor = true;
			$rfl = $cl->__rfl__();
			if($rfl === null) {
				return null;
			}
			$m = $rfl->getConstructor();
			$nargs = $m->getNumberOfRequiredParameters();
			$i = null;
			if($nargs > 0) {
				$args = array_fill(0, $m->getNumberOfRequiredParameters(), null);
				$i = $rfl->newInstanceArgs($args);
			} else {
				$i = $rfl->newInstanceArgs(array());
			}
			php_Boot::$skip_constructor = false;
			return $i;
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$e = $_ex_;
			{
				php_Boot::$skip_constructor = false;
				throw new HException("Unable to instantiate " . Std::string($cl));
			}
		}
		return null;
	}
	static function createEnum($e, $constr, $params = null) {
		$f = Reflect::field($e, $constr);
		if($f === null) {
			throw new HException("No such constructor " . _hx_string_or_null($constr));
		}
		if(Reflect::isFunction($f)) {
			if($params === null) {
				throw new HException("Constructor " . _hx_string_or_null($constr) . " need parameters");
			}
			return Reflect::callMethod($e, $f, $params);
		}
		if($params !== null && $params->length !== 0) {
			throw new HException("Constructor " . _hx_string_or_null($constr) . " does not need parameters");
		}
		return $f;
	}
	static function createEnumIndex($e, $index, $params = null) {
		$c = _hx_array_get(Type::getEnumConstructs($e), $index);
		if($c === null) {
			throw new HException(_hx_string_rec($index, "") . " is not a valid enum constructor index");
		}
		return Type::createEnum($e, $c, $params);
	}
	static function getEnumConstructs($e) {
		if($e->__tname__ == 'Bool') {
			return (new _hx_array(array("true", "false")));
		}
		if($e->__tname__ == 'Void') {
			return (new _hx_array(array()));
		}
		return new _hx_array($e->__constructors);
	}
	static function typeof($v) {
		if($v === null) {
			return ValueType::$TNull;
		}
		if(is_array($v)) {
			if(is_callable($v)) {
				return ValueType::$TFunction;
			}
			return ValueType::TClass(_hx_qtype("Array"));
		}
		if(is_string($v)) {
			if(_hx_is_lambda($v)) {
				return ValueType::$TFunction;
			}
			return ValueType::TClass(_hx_qtype("String"));
		}
		if(is_bool($v)) {
			return ValueType::$TBool;
		}
		if(is_int($v)) {
			return ValueType::$TInt;
		}
		if(is_float($v)) {
			return ValueType::$TFloat;
		}
		if($v instanceof _hx_anonymous) {
			return ValueType::$TObject;
		}
		if($v instanceof _hx_enum) {
			return ValueType::$TObject;
		}
		if($v instanceof _hx_class) {
			return ValueType::$TObject;
		}
		$c = _hx_ttype(get_class($v));
		if($c instanceof _hx_enum) {
			return ValueType::TEnum($c);
		}
		if($c instanceof _hx_class) {
			return ValueType::TClass($c);
		}
		return ValueType::$TUnknown;
	}
	function __toString() { return 'Type'; }
}
