<?php

class php_db_PDO {
	public function __construct(){}
	static function open($dsn, $user = null, $password = null, $options = null) {
		return new php_db__PDO_PDOConnection($dsn, $user, $password, $options);
	}
	function __toString() { return 'php.db.PDO'; }
}
