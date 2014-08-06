<?php

class haxe_Serializer {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->buf = new StringBuf();
		$this->cache = new _hx_array(array());
		$this->useCache = haxe_Serializer::$USE_CACHE;
		$this->useEnumIndex = haxe_Serializer::$USE_ENUM_INDEX;
		$this->shash = new haxe_ds_StringMap();
		$this->scount = 0;
	}}
	public $buf;
	public $cache;
	public $shash;
	public $scount;
	public $useCache;
	public $useEnumIndex;
	public function toString() {
		return $this->buf->b;
	}
	public function serializeString($s) {
		$x = $this->shash->get($s);
		if($x !== null) {
			$this->buf->add("R");
			$this->buf->add($x);
			return;
		}
		$this->shash->set($s, $this->scount++);
		$this->buf->add("y");
		$s = rawurlencode($s);
		$this->buf->add(strlen($s));
		$this->buf->add(":");
		$this->buf->add($s);
	}
	public function serializeRef($v) {
		{
			$_g1 = 0;
			$_g = $this->cache->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				if(_hx_equal($this->cache[$i], $v)) {
					$this->buf->add("r");
					$this->buf->add($i);
					return true;
				}
				unset($i);
			}
		}
		$this->cache->push($v);
		return false;
	}
	public function serializeFields($v) {
		{
			$_g = 0;
			$_g1 = Reflect::fields($v);
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$this->serializeString($f);
				$this->serialize(Reflect::field($v, $f));
				unset($f);
			}
		}
		$this->buf->add("g");
	}
	public function serialize($v) {
		{
			$_g = Type::typeof($v);
			switch($_g->index) {
			case 0:{
				$this->buf->add("n");
			}break;
			case 1:{
				$v1 = $v;
				if($v1 === 0) {
					$this->buf->add("z");
					return;
				}
				$this->buf->add("i");
				$this->buf->add($v1);
			}break;
			case 2:{
				$v2 = $v;
				if(Math::isNaN($v2)) {
					$this->buf->add("k");
				} else {
					if(!Math::isFinite($v2)) {
						$this->buf->add((($v2 < 0) ? "m" : "p"));
					} else {
						$this->buf->add("d");
						$this->buf->add($v2);
					}
				}
			}break;
			case 3:{
				$this->buf->add((($v) ? "t" : "f"));
			}break;
			case 6:{
				$c = $_g->params[0];
				{
					if((is_object($_t = $c) && !($_t instanceof Enum) ? $_t === _hx_qtype("String") : $_t == _hx_qtype("String"))) {
						$this->serializeString($v);
						return;
					}
					if($this->useCache && $this->serializeRef($v)) {
						return;
					}
					switch($c) {
					case _hx_qtype("Array"):{
						$ucount = 0;
						$this->buf->add("a");
						$l = _hx_len($v);
						{
							$_g1 = 0;
							while($_g1 < $l) {
								$i = $_g1++;
								if($v[$i] === null) {
									$ucount++;
								} else {
									if($ucount > 0) {
										if($ucount === 1) {
											$this->buf->add("n");
										} else {
											$this->buf->add("u");
											$this->buf->add($ucount);
										}
										$ucount = 0;
									}
									$this->serialize($v[$i]);
								}
								unset($i);
							}
						}
						if($ucount > 0) {
							if($ucount === 1) {
								$this->buf->add("n");
							} else {
								$this->buf->add("u");
								$this->buf->add($ucount);
							}
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("List"):{
						$this->buf->add("l");
						$v3 = $v;
						if(null == $v3) throw new HException('null iterable');
						$__hx__it = $v3->iterator();
						while($__hx__it->hasNext()) {
							$i1 = $__hx__it->next();
							$this->serialize($i1);
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("Date"):{
						$d = $v;
						$this->buf->add("v");
						$this->buf->add($d->toString());
					}break;
					case _hx_qtype("haxe.ds.StringMap"):{
						$this->buf->add("b");
						$v4 = $v;
						if(null == $v4) throw new HException('null iterable');
						$__hx__it = $v4->keys();
						while($__hx__it->hasNext()) {
							$k = $__hx__it->next();
							$this->serializeString($k);
							$this->serialize($v4->get($k));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.ds.IntMap"):{
						$this->buf->add("q");
						$v5 = $v;
						if(null == $v5) throw new HException('null iterable');
						$__hx__it = $v5->keys();
						while($__hx__it->hasNext()) {
							$k1 = $__hx__it->next();
							$this->buf->add(":");
							$this->buf->add($k1);
							$this->serialize($v5->get($k1));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.ds.ObjectMap"):{
						$this->buf->add("M");
						$v6 = $v;
						$__hx__it = new _hx_array_iterator(array_values($v6->hk));
						while($__hx__it->hasNext()) {
							$k2 = $__hx__it->next();
							$this->serialize($k2);
							$this->serialize($v6->get($k2));
						}
						$this->buf->add("h");
					}break;
					case _hx_qtype("haxe.io.Bytes"):{
						$v7 = $v;
						$i2 = 0;
						$max = $v7->length - 2;
						$charsBuf = new StringBuf();
						$b64 = haxe_Serializer::$BASE64;
						while($i2 < $max) {
							$b1 = null;
							{
								$pos = $i2++;
								$b1 = ord($v7->b[$pos]);
								unset($pos);
							}
							$b2 = null;
							{
								$pos1 = $i2++;
								$b2 = ord($v7->b[$pos1]);
								unset($pos1);
							}
							$b3 = null;
							{
								$pos2 = $i2++;
								$b3 = ord($v7->b[$pos2]);
								unset($pos2);
							}
							$charsBuf->add(_hx_char_at($b64, $b1 >> 2));
							$charsBuf->add(_hx_char_at($b64, ($b1 << 4 | $b2 >> 4) & 63));
							$charsBuf->add(_hx_char_at($b64, ($b2 << 2 | $b3 >> 6) & 63));
							$charsBuf->add(_hx_char_at($b64, $b3 & 63));
							unset($b3,$b2,$b1);
						}
						if($i2 === $max) {
							$b11 = null;
							{
								$pos3 = $i2++;
								$b11 = ord($v7->b[$pos3]);
							}
							$b21 = null;
							{
								$pos4 = $i2++;
								$b21 = ord($v7->b[$pos4]);
							}
							$charsBuf->add(_hx_char_at($b64, $b11 >> 2));
							$charsBuf->add(_hx_char_at($b64, ($b11 << 4 | $b21 >> 4) & 63));
							$charsBuf->add(_hx_char_at($b64, $b21 << 2 & 63));
						} else {
							if($i2 === $max + 1) {
								$b12 = null;
								{
									$pos5 = $i2++;
									$b12 = ord($v7->b[$pos5]);
								}
								$charsBuf->add(_hx_char_at($b64, $b12 >> 2));
								$charsBuf->add(_hx_char_at($b64, $b12 << 4 & 63));
							}
						}
						$chars = $charsBuf->b;
						$this->buf->add("s");
						$this->buf->add(strlen($chars));
						$this->buf->add(":");
						$this->buf->add($chars);
					}break;
					default:{
						if($this->useCache) {
							$this->cache->pop();
						}
						if(_hx_field($v, "hxSerialize") !== null) {
							$this->buf->add("C");
							$this->serializeString(Type::getClassName($c));
							if($this->useCache) {
								$this->cache->push($v);
							}
							$v->hxSerialize($this);
							$this->buf->add("g");
						} else {
							$this->buf->add("c");
							$this->serializeString(Type::getClassName($c));
							if($this->useCache) {
								$this->cache->push($v);
							}
							$this->serializeFields($v);
						}
					}break;
					}
				}
			}break;
			case 4:{
				if($this->useCache && $this->serializeRef($v)) {
					return;
				}
				$this->buf->add("o");
				$this->serializeFields($v);
			}break;
			case 7:{
				$e = $_g->params[0];
				{
					if($this->useCache) {
						if($this->serializeRef($v)) {
							return;
						}
						$this->cache->pop();
					}
					$this->buf->add((($this->useEnumIndex) ? "j" : "w"));
					$this->serializeString(Type::getEnumName($e));
					if($this->useEnumIndex) {
						$this->buf->add(":");
						$this->buf->add($v->index);
					} else {
						$this->serializeString($v->tag);
					}
					$this->buf->add(":");
					$l1 = count($v->params);
					if($l1 === 0 || _hx_field($v, "params") === null) {
						$this->buf->add(0);
					} else {
						$this->buf->add($l1);
						{
							$_g11 = 0;
							while($_g11 < $l1) {
								$i3 = $_g11++;
								$this->serialize($v->params[$i3]);
								unset($i3);
							}
						}
					}
					if($this->useCache) {
						$this->cache->push($v);
					}
				}
			}break;
			case 5:{
				throw new HException("Cannot serialize function");
			}break;
			default:{
				throw new HException("Cannot serialize " . Std::string($v));
			}break;
			}
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
	static $USE_CACHE = false;
	static $USE_ENUM_INDEX = false;
	static $BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
	function __toString() { return $this->toString(); }
}
