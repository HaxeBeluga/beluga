<?php

class haxe_Session {
	public function __construct(){}
	static $gcStartChance;
	static function set_gcStartChance($chance) {
		return $chance;
	}
	static $gcMaxLifeTime;
	static function set_gcMaxLifeTime($seconds) {
		return $seconds;
	}
	static $savePath;
	static function set_savePath($path) {
		php_Session::setSavePath($path);
		return $path;
	}
	static function start() {
		php_Session::start();
	}
	static function close() {
		php_Session::close();
	}
	static function get($name) {
		return php_Session::get($name);
	}
	static function set($name, $value) {
		php_Session::set($name, $value);
	}
	static function exists($name) {
		return php_Session::exists($name);
	}
	static function remove($name) {
		php_Session::remove($name);
	}
	static function clear() {
		php_Session::clear();
	}
	static $__properties__ = array("set_savePath" => "set_savePath","set_gcMaxLifeTime" => "set_gcMaxLifeTime","set_gcStartChance" => "set_gcStartChance");
	function __toString() { return 'haxe.Session'; }
}
