<?php

class StringTools {
	public function __construct(){}
	static function htmlEscape($s, $quotes = null) {
		$s = _hx_explode(">", _hx_explode("<", _hx_explode("&", $s)->join("&amp;"))->join("&lt;"))->join("&gt;");
		if($quotes) {
			return _hx_explode("'", _hx_explode("\"", $s)->join("&quot;"))->join("&#039;");
		} else {
			return $s;
		}
	}
	function __toString() { return 'StringTools'; }
}
