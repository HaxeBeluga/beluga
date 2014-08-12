<?php

class php_Session {
	public function __construct(){}
	static function setSavePath($path) {
		if(php_Session::$started) {
			throw new HException("You can't set the save path while the session is already in use");
		}
		session_save_path($path);
	}
	static function get($name) {
		php_Session::start();
		if(!isset($_SESSION[$name])) {
			return null;
		}
		return $_SESSION[$name];
	}
	static function set($name, $value) {
		php_Session::start();
		return $_SESSION[$name] = $value;
	}
	static function exists($name) {
		php_Session::start();
		return array_key_exists($name, $_SESSION);
	}
	static function remove($name) {
		php_Session::start();
		unset($_SESSION[$name]);
	}
	static $started;
	static function start() {
		if(php_Session::$started) {
			return;
		}
		php_Session::$started = true;
		session_start();
	}
	static function clear() {
		session_unset();
	}
	static function close() {
		session_write_close();
		php_Session::$started = false;
	}
	function __toString() { return 'php.Session'; }
}
php_Session::$started = isset($_SESSION);
