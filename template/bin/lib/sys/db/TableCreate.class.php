<?php

class sys_db_TableCreate {
	public function __construct(){}
	static function autoInc($dbName) {
		if($dbName === "SQLite") {
			return "PRIMARY KEY AUTOINCREMENT";
		} else {
			return "AUTO_INCREMENT";
		}
	}
	static function getTypeSQL($t, $dbName) {
		switch($t->index) {
		case 0:{
			return "INTEGER " . _hx_string_or_null(sys_db_TableCreate::autoInc($dbName));
		}break;
		case 2:{
			return "INTEGER UNSIGNED " . _hx_string_or_null(sys_db_TableCreate::autoInc($dbName));
		}break;
		case 1:case 20:{
			return "INTEGER";
		}break;
		case 3:{
			return "INTEGER UNSIGNED";
		}break;
		case 24:{
			return "TINYINT";
		}break;
		case 25:case 31:{
			return "TINYINT UNSIGNED";
		}break;
		case 26:{
			return "SMALLINT";
		}break;
		case 27:{
			return "SMALLINT UNSIGNED";
		}break;
		case 28:{
			return "MEDIUMINT";
		}break;
		case 29:{
			return "MEDIUMINT UNSIGNED";
		}break;
		case 6:{
			return "FLOAT";
		}break;
		case 7:{
			return "DOUBLE";
		}break;
		case 8:{
			return "TINYINT(1)";
		}break;
		case 9:{
			$n = $t->params[0];
			return "VARCHAR(" . _hx_string_rec($n, "") . ")";
		}break;
		case 10:{
			return "DATE";
		}break;
		case 11:{
			return "DATETIME";
		}break;
		case 12:{
			return "TIMESTAMP DEFAULT 0";
		}break;
		case 13:{
			return "TINYTEXT";
		}break;
		case 14:{
			return "TEXT";
		}break;
		case 15:case 21:{
			return "MEDIUMTEXT";
		}break;
		case 16:{
			return "BLOB";
		}break;
		case 18:case 22:case 30:{
			return "MEDIUMBLOB";
		}break;
		case 17:{
			return "LONGBLOB";
		}break;
		case 5:{
			return "BIGINT";
		}break;
		case 4:{
			return "BIGINT " . _hx_string_or_null(sys_db_TableCreate::autoInc($dbName));
		}break;
		case 19:{
			$n1 = $t->params[0];
			return "BINARY(" . _hx_string_rec($n1, "") . ")";
		}break;
		case 23:{
			$auto = $t->params[1];
			$fl = $t->params[0];
			return sys_db_TableCreate::getTypeSQL((($auto) ? (($fl->length <= 8) ? sys_db_RecordType::$DTinyUInt : (($fl->length <= 16) ? sys_db_RecordType::$DSmallUInt : (($fl->length <= 24) ? sys_db_RecordType::$DMediumUInt : sys_db_RecordType::$DInt))) : sys_db_RecordType::$DInt), $dbName);
		}break;
		case 33:case 32:{
			throw new HException("assert");
		}break;
		}
	}
	static function create($manager, $engine = null) {
		$quote = array(new _hx_lambda(array(&$engine, &$manager), "sys_db_TableCreate_0"), 'execute');
		$cnx = $manager->getCnx();
		if($cnx === null) {
			throw new HException("SQL Connection not initialized on Manager");
		}
		$dbName = $cnx->dbName();
		$infos = $manager->dbInfos();
		$sql = "CREATE TABLE " . _hx_string_or_null(call_user_func_array($quote, array($infos->name))) . " (";
		$decls = (new _hx_array(array()));
		$hasID = false;
		{
			$_g = 0;
			$_g1 = $infos->fields;
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				{
					$_g2 = $f->t;
					switch($_g2->index) {
					case 0:{
						$hasID = true;
					}break;
					case 2:case 4:{
						$hasID = true;
						if($dbName === "SQLite") {
							throw new HException("S" . _hx_string_or_null(_hx_substr(Std::string($f->t), 1, null)) . " is not supported by " . _hx_string_or_null($dbName) . " : use SId instead");
						}
					}break;
					default:{
					}break;
					}
					unset($_g2);
				}
				$decls->push(_hx_string_or_null(call_user_func_array($quote, array($f->name))) . " " . _hx_string_or_null(sys_db_TableCreate::getTypeSQL($f->t, $dbName)) . _hx_string_or_null(((($f->isNull) ? "" : " NOT NULL"))));
				unset($f);
			}
		}
		if($dbName !== "SQLite" || !$hasID) {
			$decls->push("PRIMARY KEY (" . _hx_string_or_null(Lambda::map($infos->key, $quote)->join(",")) . ")");
		}
		$sql .= _hx_string_or_null($decls->join(","));
		$sql .= ")";
		if($engine !== null) {
			$sql .= "ENGINE=" . _hx_string_or_null($engine);
		}
		$cnx->request($sql);
	}
	static function exists($manager) {
		$cnx = $manager->getCnx();
		if($cnx === null) {
			throw new HException("SQL Connection not initialized on Manager");
		}
		try {
			$cnx->request("SELECT * FROM `" . _hx_string_or_null($manager->dbInfos()->name) . "` LIMIT 1");
			return true;
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$e = $_ex_;
			{
				return false;
			}
		}
	}
	function __toString() { return 'sys.db.TableCreate'; }
}
function sys_db_TableCreate_0(&$engine, &$manager, $v) {
	{
		return $manager->quoteField($v);
	}
}
