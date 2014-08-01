<?php

class php_db__PDO_AllResultSet extends php_db__PDO_BaseResultSet {
	public function __construct($pdo, $typeStrategy) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct($pdo,$typeStrategy);
		$this->all = $pdo->fetchAll(PDO::FETCH_NUM);
		$this->pos = 0;
		$this->_length = count($this->all);
	}}
	public $all;
	public $pos;
	public $_length;
	public function nextRow() {
		return $this->all[$this->pos++];
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
	function __toString() { return 'php.db._PDO.AllResultSet'; }
}
