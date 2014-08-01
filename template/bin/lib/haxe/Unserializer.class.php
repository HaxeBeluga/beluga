<?php

class haxe_Unserializer {
	public function __construct($buf) {
		if(!php_Boot::$skip_constructor) {
		$this->buf = $buf;
		$this->length = strlen($buf);
		$this->pos = 0;
		$this->scache = new _hx_array(array());
		$this->cache = new _hx_array(array());
		$r = haxe_Unserializer::$DEFAULT_RESOLVER;
		if($r === null) {
			$r = _hx_qtype("Type");
			haxe_Unserializer::$DEFAULT_RESOLVER = $r;
		}
		$this->setResolver($r);
	}}
	public $buf;
	public $pos;
	public $length;
	public $cache;
	public $scache;
	public $resolver;
	public function setResolver($r) {
		if($r === null) {
			$this->resolver = _hx_anonymous(array("resolveClass" => array(new _hx_lambda(array(&$r), "haxe_Unserializer_0"), 'execute'), "resolveEnum" => array(new _hx_lambda(array(&$r), "haxe_Unserializer_1"), 'execute')));
		} else {
			$this->resolver = $r;
		}
	}
	public function readDigits() {
		$k = 0;
		$s = false;
		$fpos = $this->pos;
		while(true) {
			$c = ord(substr($this->buf,$this->pos,1));
			if(($c === 0)) {
				break;
			}
			if($c === 45) {
				if($this->pos !== $fpos) {
					break;
				}
				$s = true;
				$this->pos++;
				continue;
			}
			if($c < 48 || $c > 57) {
				break;
			}
			$k = $k * 10 + ($c - 48);
			$this->pos++;
			unset($c);
		}
		if($s) {
			$k *= -1;
		}
		return $k;
	}
	public function unserializeObject($o) {
		while(true) {
			if($this->pos >= $this->length) {
				throw new HException("Invalid object");
			}
			if(ord(substr($this->buf,$this->pos,1)) === 103) {
				break;
			}
			$k = $this->unserialize();
			if(!Std::is($k, _hx_qtype("String"))) {
				throw new HException("Invalid object key");
			}
			$v = $this->unserialize();
			$o->{$k} = $v;
			unset($v,$k);
		}
		$this->pos++;
	}
	public function unserializeEnum($edecl, $tag) {
		if(haxe_Unserializer_2($this, $edecl, $tag) !== 58) {
			throw new HException("Invalid enum format");
		}
		$nargs = $this->readDigits();
		if($nargs === 0) {
			return Type::createEnum($edecl, $tag, null);
		}
		$args = new _hx_array(array());
		while($nargs-- > 0) {
			$args->push($this->unserialize());
		}
		return Type::createEnum($edecl, $tag, $args);
	}
	public function unserialize() {
		{
			$_g = null;
			{
				$p = $this->pos++;
				$_g = ord(substr($this->buf,$p,1));
			}
			switch($_g) {
			case 110:{
				return null;
			}break;
			case 116:{
				return true;
			}break;
			case 102:{
				return false;
			}break;
			case 122:{
				return 0;
			}break;
			case 105:{
				return $this->readDigits();
			}break;
			case 100:{
				$p1 = $this->pos;
				while(true) {
					$c = ord(substr($this->buf,$this->pos,1));
					if($c >= 43 && $c < 58 || $c === 101 || $c === 69) {
						$this->pos++;
					} else {
						break;
					}
					unset($c);
				}
				return Std::parseFloat(_hx_substr($this->buf, $p1, $this->pos - $p1));
			}break;
			case 121:{
				$len = $this->readDigits();
				if(haxe_Unserializer_3($this, $_g, $len) !== 58 || $this->length - $this->pos < $len) {
					throw new HException("Invalid string length");
				}
				$s = _hx_substr($this->buf, $this->pos, $len);
				$this->pos += $len;
				$s = urldecode($s);
				$this->scache->push($s);
				return $s;
			}break;
			case 107:{
				return Math::$NaN;
			}break;
			case 109:{
				return Math::$NEGATIVE_INFINITY;
			}break;
			case 112:{
				return Math::$POSITIVE_INFINITY;
			}break;
			case 97:{
				$buf = $this->buf;
				$a = new _hx_array(array());
				$this->cache->push($a);
				while(true) {
					$c1 = ord(substr($this->buf,$this->pos,1));
					if($c1 === 104) {
						$this->pos++;
						break;
					}
					if($c1 === 117) {
						$this->pos++;
						$n = $this->readDigits();
						$a[$a->length + $n - 1] = null;
						unset($n);
					} else {
						$a->push($this->unserialize());
					}
					unset($c1);
				}
				return $a;
			}break;
			case 111:{
				$o = _hx_anonymous(array());
				$this->cache->push($o);
				$this->unserializeObject($o);
				return $o;
			}break;
			case 114:{
				$n1 = $this->readDigits();
				if($n1 < 0 || $n1 >= $this->cache->length) {
					throw new HException("Invalid reference");
				}
				return $this->cache[$n1];
			}break;
			case 82:{
				$n2 = $this->readDigits();
				if($n2 < 0 || $n2 >= $this->scache->length) {
					throw new HException("Invalid string reference");
				}
				return $this->scache[$n2];
			}break;
			case 120:{
				throw new HException($this->unserialize());
			}break;
			case 99:{
				$name = $this->unserialize();
				$cl = $this->resolver->resolveClass($name);
				if($cl === null) {
					throw new HException("Class not found " . _hx_string_or_null($name));
				}
				$o1 = Type::createEmptyInstance($cl);
				$this->cache->push($o1);
				$this->unserializeObject($o1);
				return $o1;
			}break;
			case 119:{
				$name1 = $this->unserialize();
				$edecl = $this->resolver->resolveEnum($name1);
				if($edecl === null) {
					throw new HException("Enum not found " . _hx_string_or_null($name1));
				}
				$e = $this->unserializeEnum($edecl, $this->unserialize());
				$this->cache->push($e);
				return $e;
			}break;
			case 106:{
				$name2 = $this->unserialize();
				$edecl1 = $this->resolver->resolveEnum($name2);
				if($edecl1 === null) {
					throw new HException("Enum not found " . _hx_string_or_null($name2));
				}
				$this->pos++;
				$index = $this->readDigits();
				$tag = _hx_array_get(Type::getEnumConstructs($edecl1), $index);
				if($tag === null) {
					throw new HException("Unknown enum index " . _hx_string_or_null($name2) . "@" . _hx_string_rec($index, ""));
				}
				$e1 = $this->unserializeEnum($edecl1, $tag);
				$this->cache->push($e1);
				return $e1;
			}break;
			case 108:{
				$l = new HList();
				$this->cache->push($l);
				$buf1 = $this->buf;
				while(ord(substr($this->buf,$this->pos,1)) !== 104) {
					$l->add($this->unserialize());
				}
				$this->pos++;
				return $l;
			}break;
			case 98:{
				$h = new haxe_ds_StringMap();
				$this->cache->push($h);
				$buf2 = $this->buf;
				while(ord(substr($this->buf,$this->pos,1)) !== 104) {
					$s1 = $this->unserialize();
					$h->set($s1, $this->unserialize());
					unset($s1);
				}
				$this->pos++;
				return $h;
			}break;
			case 113:{
				$h1 = new haxe_ds_IntMap();
				$this->cache->push($h1);
				$buf3 = $this->buf;
				$c2 = null;
				{
					$p3 = $this->pos++;
					$c2 = ord(substr($this->buf,$p3,1));
				}
				while($c2 === 58) {
					$i = $this->readDigits();
					$h1->set($i, $this->unserialize());
					{
						$p4 = $this->pos++;
						$c2 = ord(substr($this->buf,$p4,1));
						unset($p4);
					}
					unset($i);
				}
				if($c2 !== 104) {
					throw new HException("Invalid IntMap format");
				}
				return $h1;
			}break;
			case 77:{
				$h2 = new haxe_ds_ObjectMap();
				$this->cache->push($h2);
				$buf4 = $this->buf;
				while(ord(substr($this->buf,$this->pos,1)) !== 104) {
					$s2 = $this->unserialize();
					$h2->set($s2, $this->unserialize());
					unset($s2);
				}
				$this->pos++;
				return $h2;
			}break;
			case 118:{
				$d = Date::fromString(_hx_substr($this->buf, $this->pos, 19));
				$this->cache->push($d);
				$this->pos += 19;
				return $d;
			}break;
			case 115:{
				$len1 = $this->readDigits();
				$buf5 = $this->buf;
				if(haxe_Unserializer_4($this, $_g, $buf5, $len1) !== 58 || $this->length - $this->pos < $len1) {
					throw new HException("Invalid bytes length");
				}
				$codes = haxe_Unserializer::$CODES;
				if($codes === null) {
					$codes = haxe_Unserializer::initCodes();
					haxe_Unserializer::$CODES = $codes;
				}
				$i1 = $this->pos;
				$rest = $len1 & 3;
				$size = null;
				$size = ($len1 >> 2) * 3 + (haxe_Unserializer_5($this, $_g, $buf5, $codes, $i1, $len1, $rest, $size));
				$max = $i1 + ($len1 - $rest);
				$bytes = haxe_io_Bytes::alloc($size);
				$bpos = 0;
				while($i1 < $max) {
					$c11 = $codes[haxe_Unserializer_6($this, $_g, $bpos, $buf5, $bytes, $codes, $i1, $len1, $max, $rest, $size)];
					$c21 = $codes[haxe_Unserializer_7($this, $_g, $bpos, $buf5, $bytes, $c11, $codes, $i1, $len1, $max, $rest, $size)];
					{
						$pos = $bpos++;
						$bytes->b[$pos] = chr($c11 << 2 | $c21 >> 4);
						unset($pos);
					}
					$c3 = $codes[haxe_Unserializer_8($this, $_g, $bpos, $buf5, $bytes, $c11, $c21, $codes, $i1, $len1, $max, $rest, $size)];
					{
						$pos1 = $bpos++;
						$bytes->b[$pos1] = chr($c21 << 4 | $c3 >> 2);
						unset($pos1);
					}
					$c4 = $codes[haxe_Unserializer_9($this, $_g, $bpos, $buf5, $bytes, $c11, $c21, $c3, $codes, $i1, $len1, $max, $rest, $size)];
					{
						$pos2 = $bpos++;
						$bytes->b[$pos2] = chr($c3 << 6 | $c4);
						unset($pos2);
					}
					unset($c4,$c3,$c21,$c11);
				}
				if($rest >= 2) {
					$c12 = $codes[haxe_Unserializer_10($this, $_g, $bpos, $buf5, $bytes, $codes, $i1, $len1, $max, $rest, $size)];
					$c22 = $codes[haxe_Unserializer_11($this, $_g, $bpos, $buf5, $bytes, $c12, $codes, $i1, $len1, $max, $rest, $size)];
					{
						$pos3 = $bpos++;
						$bytes->b[$pos3] = chr($c12 << 2 | $c22 >> 4);
					}
					if($rest === 3) {
						$c31 = $codes[haxe_Unserializer_12($this, $_g, $bpos, $buf5, $bytes, $c12, $c22, $codes, $i1, $len1, $max, $rest, $size)];
						{
							$pos4 = $bpos++;
							$bytes->b[$pos4] = chr($c22 << 4 | $c31 >> 2);
						}
					}
				}
				$this->pos += $len1;
				$this->cache->push($bytes);
				return $bytes;
			}break;
			case 67:{
				$name3 = $this->unserialize();
				$cl1 = $this->resolver->resolveClass($name3);
				if($cl1 === null) {
					throw new HException("Class not found " . _hx_string_or_null($name3));
				}
				$o2 = Type::createEmptyInstance($cl1);
				$this->cache->push($o2);
				$o2->hxUnserialize($this);
				if(haxe_Unserializer_13($this, $_g, $cl1, $name3, $o2) !== 103) {
					throw new HException("Invalid custom data");
				}
				return $o2;
			}break;
			default:{
			}break;
			}
		}
		$this->pos--;
		throw new HException("Invalid char " . _hx_string_or_null(_hx_char_at($this->buf, $this->pos)) . " at position " . _hx_string_rec($this->pos, ""));
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
	static $DEFAULT_RESOLVER;
	static $BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
	static $CODES = null;
	static function initCodes() {
		$codes = new _hx_array(array());
		{
			$_g1 = 0;
			$_g = strlen(haxe_Unserializer::$BASE64);
			while($_g1 < $_g) {
				$i = $_g1++;
				$codes[ord(substr(haxe_Unserializer::$BASE64,$i,1))] = $i;
				unset($i);
			}
		}
		return $codes;
	}
	static function run($v) {
		return _hx_deref(new haxe_Unserializer($v))->unserialize();
	}
	function __toString() { return 'haxe.Unserializer'; }
}
haxe_Unserializer::$DEFAULT_RESOLVER = _hx_qtype("Type");
function haxe_Unserializer_0(&$r, $_) {
	{
		return null;
	}
}
function haxe_Unserializer_1(&$r, $_1) {
	{
		return null;
	}
}
function haxe_Unserializer_2(&$__hx__this, &$edecl, &$tag) {
	{
		$p = $__hx__this->pos++;
		return ord(substr($__hx__this->buf,$p,1));
	}
}
function haxe_Unserializer_3(&$__hx__this, &$_g, &$len) {
	{
		$p2 = $__hx__this->pos++;
		return ord(substr($__hx__this->buf,$p2,1));
	}
}
function haxe_Unserializer_4(&$__hx__this, &$_g, &$buf5, &$len1) {
	{
		$p5 = $__hx__this->pos++;
		return ord(substr($__hx__this->buf,$p5,1));
	}
}
function haxe_Unserializer_5(&$__hx__this, &$_g, &$buf5, &$codes, &$i1, &$len1, &$rest, &$size) {
	if($rest >= 2) {
		return $rest - 1;
	} else {
		return 0;
	}
}
function haxe_Unserializer_6(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index1 = $i1++;
		return ord(substr($buf5,$index1,1));
	}
}
function haxe_Unserializer_7(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$c11, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index2 = $i1++;
		return ord(substr($buf5,$index2,1));
	}
}
function haxe_Unserializer_8(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$c11, &$c21, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index3 = $i1++;
		return ord(substr($buf5,$index3,1));
	}
}
function haxe_Unserializer_9(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$c11, &$c21, &$c3, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index4 = $i1++;
		return ord(substr($buf5,$index4,1));
	}
}
function haxe_Unserializer_10(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index5 = $i1++;
		return ord(substr($buf5,$index5,1));
	}
}
function haxe_Unserializer_11(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$c12, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index6 = $i1++;
		return ord(substr($buf5,$index6,1));
	}
}
function haxe_Unserializer_12(&$__hx__this, &$_g, &$bpos, &$buf5, &$bytes, &$c12, &$c22, &$codes, &$i1, &$len1, &$max, &$rest, &$size) {
	{
		$index7 = $i1++;
		return ord(substr($buf5,$index7,1));
	}
}
function haxe_Unserializer_13(&$__hx__this, &$_g, &$cl1, &$name3, &$o2) {
	{
		$p6 = $__hx__this->pos++;
		return ord(substr($__hx__this->buf,$p6,1));
	}
}
