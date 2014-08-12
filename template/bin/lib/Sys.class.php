<?php

class Sys {
	public function __construct(){}
	static function hprint($v) {
		echo(Std::string($v));
	}
	function __toString() { return 'Sys'; }
}
