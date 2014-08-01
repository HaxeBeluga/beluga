<?php

class php_db__PDO_PDOConnection implements sys_db_Connection{
	public function __construct($dsn, $user = null, $password = null, $options = null) {
		if(!php_Boot::$skip_constructor) {
		if(null === $options) {
			$this->pdo = new PDO($dsn, $user, $password);
		} else {
			$arr = array();
			{
				$_g = 0;
				$_g1 = Reflect::fields($options);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$arr[$key] = Reflect::field($options, $key);
					unset($key);
				}
			}
			$this->pdo = new PDO($dsn, $user, $password, $arr);
		}
		$this->dbname = _hx_explode(":", $dsn)->shift();
	}}
	public $pdo;
	public $dbname;
	public function request($s) {
		$result = $this->pdo->query($s, PDO::PARAM_STR);
		if(($result === false)) {
			$info = null;
			{
				$a = $this->pdo->errorInfo();
				$info = new _hx_array($a);
			}
			throw new HException("Error while executing " . _hx_string_or_null($s) . " (" . _hx_string_or_null($info[2]) . ")");
		}
		$db = strtolower($this->dbname);
		switch($db) {
		case "sqlite":{
			return new php_db__PDO_AllResultSet($result, new php_db__PDO_DBNativeStrategy($db));
		}break;
		default:{
			return new php_db__PDO_PDOResultSet($result, new php_db__PDO_PHPNativeStrategy());
		}break;
		}
	}
	public function quote($s) {
		if(_hx_index_of($s, "\x00", null) >= 0) {
			return "x'" . _hx_string_or_null($this->base16_encode($s)) . "'";
		}
		return $this->pdo->quote($s, null);
	}
	public function addValue($s, $v) {
		if(is_int($v) || is_null($v)) {
			$s->add($v);
		} else {
			if(is_bool($v)) {
				$s->add((($v) ? 1 : 0));
			} else {
				$s->add($this->quote(Std::string($v)));
			}
		}
	}
	public function lastInsertId() {
		return Std::parseInt($this->pdo->lastInsertId(null));
	}
	public function dbName() {
		return $this->dbname;
	}
	public function base16_encode($str) {
		$str = unpack("H" . _hx_string_rec(2 * strlen($str), ""), $str);
		$str = chunk_split($str[1]);
		return $str;
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
	function __toString() { return 'php.db._PDO.PDOConnection'; }
}
