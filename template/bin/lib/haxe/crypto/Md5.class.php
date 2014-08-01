<?php

class haxe_crypto_Md5 {
	public function __construct(){}
	static function encode($s) {
		return md5($s);
	}
	function __toString() { return 'haxe.crypto.Md5'; }
}
