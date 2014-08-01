<?php

class EReg {
	public function __construct($r, $opt) {
		if(!php_Boot::$skip_constructor) {
		$this->pattern = $r;
		$a = _hx_explode("g", $opt);
		$this->{"global"} = $a->length > 1;
		if($this->{"global"}) {
			$opt = $a->join("");
		}
		$this->options = $opt;
		$this->re = '"' . str_replace('"','\\"',$r) . '"' . $opt;
	}}
	public $last;
	public $global;
	public $pattern;
	public $options;
	public $re;
	public $matches;
	public function match($s) {
		$p = preg_match($this->re, $s, $this->matches, PREG_OFFSET_CAPTURE);
		if($p > 0) {
			$this->last = $s;
		} else {
			$this->last = null;
		}
		return $p > 0;
	}
	public function matched($n) {
		if($this->matches === null || $n < 0) {
			throw new HException("EReg::matched");
		}
		if($n >= count($this->matches)) {
			return null;
		}
		if($this->matches[$n][1] < 0) {
			return null;
		}
		return $this->matches[$n][0];
	}
	public function matchedRight() {
		if(count($this->matches) === 0) {
			throw new HException("No string matched");
		}
		$x = $this->matches[0][1] + strlen($this->matches[0][0]);
		return _hx_substr($this->last, $x, null);
	}
	public function matchedPos() {
		return _hx_anonymous(array("pos" => $this->matches[0][1], "len" => strlen($this->matches[0][0])));
	}
	public function replace($s, $by) {
		$by = str_replace("\\\$", "\\\\\$", $by);
		$by = str_replace("\$\$", "\\\$", $by);
		if(!preg_match('/\\([^?].+?\\)/', $this->re)) $by = preg_replace('/\$(\d+)/', '\\\$\1', $by);
		return preg_replace($this->re, $by, $s, (($this->{"global"}) ? -1 : 1));
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
	function __toString() { return 'EReg'; }
}
