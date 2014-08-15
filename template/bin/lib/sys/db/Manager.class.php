<?php

class sys_db_Manager {
	public function __construct($classval) {
		if(!php_Boot::$skip_constructor) {
		$m = haxe_rtti_Meta::getType($classval)->rtti;
		if($m === null) {
			throw new HException("Missing @rtti for class " . _hx_string_or_null(Type::getClassName($classval)));
		}
		$this->table_infos = haxe_Unserializer::run($m[0]);
		$this->table_name = $this->quoteField($this->table_infos->name);
		$this->table_keys = $this->table_infos->key;
		$this->class_proto = $classval;
	}}
	public $table_infos;
	public $table_name;
	public $table_keys;
	public $class_proto;
	public function doUpdateCache($x, $name, $v) {
		$cache = Reflect::field($x, "cache_" . _hx_string_or_null($name));
		if($cache === null) {
			return $v;
		}
		$v1 = $this->doSerialize($name, $cache->v);
		return $v1;
	}
	public function doInsert($x) {
		$this->unmake($x);
		$s = new StringBuf();
		$fields = new HList();
		$values = new HList();
		{
			$_g = 0;
			$_g1 = $this->table_infos->fields;
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$name = $f->name;
				$v = Reflect::field($x, $name);
				if($v !== null) {
					$fields->add($this->quoteField($name));
					{
						$_g2 = $f->t;
						switch($_g2->index) {
						case 30:{
							$v = $this->doUpdateCache($x, $name, $v);
						}break;
						default:{
						}break;
						}
						unset($_g2);
					}
					$values->add($v);
				} else {
					if(!$f->isNull) {
						{
							$_g21 = $f->t;
							switch($_g21->index) {
							case 3:case 24:case 1:case 6:case 7:case 23:case 5:case 25:case 26:case 27:case 28:case 29:case 31:{
								$x->{$name} = 0;
							}break;
							case 8:{
								$x->{$name} = false;
							}break;
							case 13:case 15:case 9:case 14:case 21:{
								$x->{$name} = "";
							}break;
							case 16:case 22:case 17:case 19:case 18:{
								$value = haxe_io_Bytes::alloc(0);
								$x->{$name} = $value;
							}break;
							case 10:case 11:case 12:{
							}break;
							case 0:case 2:case 4:case 33:case 32:case 20:case 30:{
							}break;
							}
							unset($_g21);
						}
					}
				}
				unset($v,$name,$f);
			}
		}
		$s->add("INSERT INTO ");
		$s->add($this->table_name);
		$s->add(" (");
		$s->add($fields->join(","));
		$s->add(") VALUES (");
		$first = true;
		if(null == $values) throw new HException('null iterable');
		$__hx__it = $values->iterator();
		while($__hx__it->hasNext()) {
			$v1 = $__hx__it->next();
			if($first) {
				$first = false;
			} else {
				$s->add(", ");
			}
			$this->getCnx()->addValue($s, $v1);
		}
		$s->add(")");
		$this->unsafeExecute($s->b);
		$x->_lock = true;
		if($this->table_keys->length === 1 && Reflect::field($x, $this->table_keys[0]) === null) {
			$value1 = $this->getCnx()->lastInsertId();
			$x->{$this->table_keys[0]} = $value1;
		}
		$this->addToCache($x);
	}
	public function doUpdate($x) {
		if(!$x->_lock) {
			throw new HException("Cannot update a not locked object");
		}
		$this->unmake($x);
		$s = new StringBuf();
		$s->add("UPDATE ");
		$s->add($this->table_name);
		$s->add(" SET ");
		$cache = Reflect::field($x, "__cache__");
		$mod = false;
		{
			$_g = 0;
			$_g1 = $this->table_infos->fields;
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$name = $f->name;
				$v = Reflect::field($x, $name);
				$vc = Reflect::field($cache, $name);
				if(!_hx_equal($v, $vc) && (!sys_db_Manager_0($this, $_g, $_g1, $cache, $f, $mod, $name, $s, $v, $vc, $x) || sys_db_Manager_1($this, $_g, $_g1, $cache, $f, $mod, $name, $s, $v, $vc, $x))) {
					{
						$_g2 = $f->t;
						switch($_g2->index) {
						case 30:{
							$v = $this->doUpdateCache($x, $name, $v);
							if(!sys_db_Manager_2($this, $_g, $_g1, $_g2, $cache, $f, $mod, $name, $s, $v, $vc, $x)) {
								continue 2;
							}
						}break;
						default:{
						}break;
						}
						unset($_g2);
					}
					if($mod) {
						$s->add(", ");
					} else {
						$mod = true;
					}
					$s->add($this->quoteField($name));
					$s->add(" = ");
					$this->getCnx()->addValue($s, $v);
					$cache->{$name} = $v;
				}
				unset($vc,$v,$name,$f);
			}
		}
		if(!$mod) {
			return;
		}
		$s->add(" WHERE ");
		$this->addKeys($s, $x);
		$this->unsafeExecute($s->b);
	}
	public function doDelete($x) {
		$s = new StringBuf();
		$s->add("DELETE FROM ");
		$s->add($this->table_name);
		$s->add(" WHERE ");
		$this->addKeys($s, $x);
		$this->unsafeExecute($s->b);
		$this->removeFromCache($x);
	}
	public function doLock($i) {
		if($i->_lock) {
			return;
		}
		$s = new StringBuf();
		$s->add("SELECT * FROM ");
		$s->add($this->table_name);
		$s->add(" WHERE ");
		$this->addKeys($s, $i);
		if((is_object($_t = $this->unsafeObject($s->b, true)) && !($_t instanceof Enum) ? $_t !== $i : $_t != $i)) {
			throw new HException("Could not lock object (was deleted ?); try restarting transaction");
		}
	}
	public function objectToString($it) {
		$s = new StringBuf();
		$s->add($this->table_name);
		if($this->table_keys->length === 1) {
			$s->add("#");
			$s->add(Reflect::field($it, $this->table_keys[0]));
		} else {
			$s->add("(");
			$first = true;
			{
				$_g = 0;
				$_g1 = $this->table_keys;
				while($_g < $_g1->length) {
					$f = $_g1[$_g];
					++$_g;
					if($first) {
						$first = false;
					} else {
						$s->add(",");
					}
					$s->add($this->quoteField($f));
					$s->add(":");
					$s->add(Reflect::field($it, $f));
					unset($f);
				}
			}
			$s->add(")");
		}
		return $s->b;
	}
	public function doSerialize($field, $v) {
		$s = new haxe_Serializer();
		$s->useEnumIndex = true;
		$s->serialize($v);
		$str = $s->toString();
		return haxe_io_Bytes::ofString($str);
	}
	public function cacheObject($x, $lock) {
		$o = Type::createEmptyInstance($this->class_proto);
		{
			$_g = 0;
			$_g1 = Reflect::fields($x);
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$value = Reflect::field($x, $f);
				$o->{$f} = $value;
				unset($value,$f);
			}
		}
		$o->_manager = $this;
		$o->{"__cache__"} = $x;
		$this->addToCache($o);
		$o->_lock = $lock;
		return $o;
	}
	public function make($x) {
	}
	public function unmake($x) {
	}
	public function quoteField($f) {
		if(sys_db_Manager::$KEYWORDS->exists(strtolower($f))) {
			return "`" . _hx_string_or_null($f) . "`";
		} else {
			return $f;
		}
	}
	public function addKeys($s, $x) {
		$first = true;
		{
			$_g = 0;
			$_g1 = $this->table_keys;
			while($_g < $_g1->length) {
				$k = $_g1[$_g];
				++$_g;
				if($first) {
					$first = false;
				} else {
					$s->add(" AND ");
				}
				$s->add($this->quoteField($k));
				$s->add(" = ");
				$f = Reflect::field($x, $k);
				if($f === null) {
					throw new HException("Missing key " . _hx_string_or_null($k));
				}
				$this->getCnx()->addValue($s, $f);
				unset($k,$f);
			}
		}
	}
	public function unsafeExecute($sql) {
		return $this->getCnx()->request($sql);
	}
	public function unsafeObject($sql, $lock) {
		if($lock !== false) {
			$lock = true;
			$sql .= _hx_string_or_null($this->getLockMode());
		}
		$r = $this->unsafeExecute($sql)->next();
		if($r === null) {
			return null;
		}
		$c = $this->getFromCache($r, $lock);
		if($c !== null) {
			return $c;
		}
		$r = $this->cacheObject($r, $lock);
		$this->make($r);
		return $r;
	}
	public function unsafeGet($id, $lock = null) {
		if($lock === null) {
			$lock = true;
		}
		if($this->table_keys->length !== 1) {
			throw new HException("Invalid number of keys");
		}
		if($id === null) {
			return null;
		}
		$x = $this->getFromCacheKey(Std::string($id) . _hx_string_or_null($this->table_name));
		if($x !== null && (!$lock || $x->_lock)) {
			return $x;
		}
		$s = new StringBuf();
		$s->add("SELECT * FROM ");
		$s->add($this->table_name);
		$s->add(" WHERE ");
		$s->add($this->quoteField($this->table_keys[0]));
		$s->add(" = ");
		$this->getCnx()->addValue($s, $id);
		return $this->unsafeObject($s->b, $lock);
	}
	public function dbInfos() {
		return $this->table_infos;
	}
	public function getCnx() {
		return sys_db_Manager::$cnx;
	}
	public function getLockMode() {
		return sys_db_Manager::$lockMode;
	}
	public function initRelation($r) {
		$spod = Type::resolveClass($r->type);
		if($spod === null) {
			throw new HException("Missing spod type " . _hx_string_or_null($r->type));
		}
		$manager = $spod->manager;
		$hprop = "__" . _hx_string_or_null($r->prop);
		$hkey = $r->key;
		$lock = $r->lock;
		if($manager === null || $manager->table_keys === null) {
			throw new HException("Invalid manager for relation " . _hx_string_or_null($this->table_name) . ":" . _hx_string_or_null($r->prop));
		}
		if($manager->table_keys->length !== 1) {
			throw new HException("Relation " . _hx_string_or_null($r->prop) . "(" . _hx_string_or_null($r->key) . ") on a multiple key table");
		}
		$this->class_proto->prototype->{"get_" . _hx_string_or_null($r->prop)} = array(new _hx_lambda(array(&$hkey, &$hprop, &$lock, &$manager, &$r, &$spod), "sys_db_Manager_3"), 'execute');
		$this->class_proto->prototype->{"set_" . _hx_string_or_null($r->prop)} = array(new _hx_lambda(array(&$hkey, &$hprop, &$lock, &$manager, &$r, &$spod), "sys_db_Manager_4"), 'execute');
	}
	public function h__get($x, $prop, $key, $lock) {
		$v = Reflect::field($x, $prop);
		if($v !== null) {
			return $v->value;
		}
		$y = $this->unsafeGet(Reflect::field($x, $key), $lock);
		$x->{$prop} = _hx_anonymous(array("value" => $y));
		return $y;
	}
	public function h__set($x, $prop, $key, $v) {
		$x->{$prop} = _hx_anonymous(array("value" => $v));
		if($v === null) {
			$x->{$key} = null;
		} else {
			$value = Reflect::field($v, $this->table_keys[0]);
			$x->{$key} = $value;
		}
	}
	public function makeCacheKey($x) {
		if($this->table_keys->length === 1) {
			$k = Reflect::field($x, $this->table_keys[0]);
			if($k === null) {
				throw new HException("Missing key " . _hx_string_or_null($this->table_keys[0]));
			}
			return Std::string($k) . _hx_string_or_null($this->table_name);
		}
		$s = new StringBuf();
		{
			$_g = 0;
			$_g1 = $this->table_keys;
			while($_g < $_g1->length) {
				$k1 = $_g1[$_g];
				++$_g;
				$v = Reflect::field($x, $k1);
				if($k1 === null) {
					throw new HException("Missing key " . _hx_string_or_null($k1));
				}
				$s->add($v);
				$s->add("#");
				unset($v,$k1);
			}
		}
		$s->add($this->table_name);
		return $s->b;
	}
	public function addToCache($x) {
		sys_db_Manager::$object_cache->set($this->makeCacheKey($x), $x);
	}
	public function removeFromCache($x) {
		sys_db_Manager::$object_cache->remove($this->makeCacheKey($x));
	}
	public function getFromCacheKey($key) {
		return sys_db_Manager::$object_cache->get($key);
	}
	public function getFromCache($x, $lock) {
		$c = sys_db_Manager::$object_cache->get($this->makeCacheKey($x));
		if($c !== null && $lock && !$c->_lock) {
			{
				$_g = 0;
				$_g1 = Reflect::fields($c);
				while($_g < $_g1->length) {
					$f = $_g1[$_g];
					++$_g;
					Reflect::deleteField($c, $f);
					unset($f);
				}
			}
			{
				$_g2 = 0;
				$_g11 = Reflect::fields($x);
				while($_g2 < $_g11->length) {
					$f1 = $_g11[$_g2];
					++$_g2;
					$value = Reflect::field($x, $f1);
					$c->{$f1} = $value;
					unset($value,$f1);
				}
			}
			$c->_lock = true;
			$c->_manager = $this;
			$c->{"__cache__"} = $x;
			$this->make($c);
		}
		return $c;
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
	static $cnx;
	static $lockMode;
	static $object_cache;
	static $init_list;
	static $KEYWORDS;
	static function set_cnx($c) {
		sys_db_Manager::$cnx = $c;
		if($c !== null && $c->dbName() === "MySQL") {
			sys_db_Manager::$lockMode = " FOR UPDATE";
		} else {
			sys_db_Manager::$lockMode = "";
		}
		return $c;
	}
	static function initialize() {
		$l = sys_db_Manager::$init_list;
		sys_db_Manager::$init_list = new HList();
		if(null == $l) throw new HException('null iterable');
		$__hx__it = $l->iterator();
		while($__hx__it->hasNext()) {
			$m = $__hx__it->next();
			$_g = 0;
			$_g1 = $m->table_infos->relations;
			while($_g < $_g1->length) {
				$r = $_g1[$_g];
				++$_g;
				$m->initRelation($r);
				unset($r);
			}
			unset($_g1,$_g);
		}
	}
	static function cleanup() {
		sys_db_Manager::$object_cache = new haxe_ds_StringMap();
	}
	static $__properties__ = array("set_cnx" => "set_cnx");
	function __toString() { return 'sys.db.Manager'; }
}
sys_db_Manager::$object_cache = new haxe_ds_StringMap();
sys_db_Manager::$init_list = new HList();
sys_db_Manager::$KEYWORDS = sys_db_Manager_5();
function sys_db_Manager_0(&$__hx__this, &$_g, &$_g1, &$cache, &$f, &$mod, &$name, &$s, &$v, &$vc, &$x) {
	switch($f->t->index) {
	case 16:case 22:case 17:case 19:case 18:{
		return true;
	}break;
	default:{
		return false;
	}break;
	}
}
function sys_db_Manager_1(&$__hx__this, &$_g, &$_g1, &$cache, &$f, &$mod, &$name, &$s, &$v, &$vc, &$x) {
	{
		$a = $v;
		$b = $vc;
		return $a !== $b && ($a === null || $b === null || $a->compare($b) !== 0);
	}
}
function sys_db_Manager_2(&$__hx__this, &$_g, &$_g1, &$_g2, &$cache, &$f, &$mod, &$name, &$s, &$v, &$vc, &$x) {
	{
		$a1 = $v;
		$b1 = $vc;
		return $a1 !== $b1 && ($a1 === null || $b1 === null || $a1->compare($b1) !== 0);
	}
}
function sys_db_Manager_3(&$hkey, &$hprop, &$lock, &$manager, &$r, &$spod) {
	{
		$othis = $__hx__this;
		$f = Reflect::field($othis, $hprop);
		if($f !== null) {
			return $f;
		}
		$id = Reflect::field($othis, $hkey);
		if($id === null) {
			return null;
		}
		$f = $manager->unsafeGet($id, $lock);
		if($f === null && $id !== null && !$lock) {
			$f = $manager->unsafeGet($id, true);
		}
		$othis->{$hprop} = $f;
		return $f;
	}
}
function sys_db_Manager_4(&$hkey, &$hprop, &$lock, &$manager, &$r, &$spod, $f1) {
	{
		$othis1 = $__hx__this;
		$othis1->{$hprop} = $f1;
		{
			$value = Reflect::field($f1, $manager->table_keys[0]);
			$othis1->{$hkey} = $value;
		}
		return $f1;
	}
}
function sys_db_Manager_5() {
	{
		$h = new haxe_ds_StringMap();
		{
			$_g = 0;
			$_g1 = _hx_explode("|", "ADD|ALL|ALTER|ANALYZE|AND|AS|ASC|ASENSITIVE|BEFORE|BETWEEN|BIGINT|BINARY|BLOB|BOTH|BY|CALL|CASCADE|CASE|CHANGE|CHAR|CHARACTER|CHECK|COLLATE|COLUMN|CONDITION|CONSTRAINT|CONTINUE|CONVERT|CREATE|CROSS|CURRENT_DATE|CURRENT_TIME|CURRENT_TIMESTAMP|CURRENT_USER|CURSOR|DATABASE|DATABASES|DAY_HOUR|DAY_MICROSECOND|DAY_MINUTE|DAY_SECOND|DEC|DECIMAL|DECLARE|DEFAULT|DELAYED|DELETE|DESC|DESCRIBE|DETERMINISTIC|DISTINCT|DISTINCTROW|DIV|DOUBLE|DROP|DUAL|EACH|ELSE|ELSEIF|ENCLOSED|ESCAPED|EXISTS|EXIT|EXPLAIN|FALSE|FETCH|FLOAT|FLOAT4|FLOAT8|FOR|FORCE|FOREIGN|FROM|FULLTEXT|GRANT|GROUP|HAVING|HIGH_PRIORITY|HOUR_MICROSECOND|HOUR_MINUTE|HOUR_SECOND|IF|IGNORE|IN|INDEX|INFILE|INNER|INOUT|INSENSITIVE|INSERT|INT|INT1|INT2|INT3|INT4|INT8|INTEGER|INTERVAL|INTO|IS|ITERATE|JOIN|KEY|KEYS|KILL|LEADING|LEAVE|LEFT|LIKE|LIMIT|LINES|LOAD|LOCALTIME|LOCALTIMESTAMP|LOCK|LONG|LONGBLOB|LONGTEXT|LOOP|LOW_PRIORITY|MATCH|MEDIUMBLOB|MEDIUMINT|MEDIUMTEXT|MIDDLEINT|MINUTE_MICROSECOND|MINUTE_SECOND|MOD|MODIFIES|NATURAL|NOT|NO_WRITE_TO_BINLOG|NULL|NUMERIC|ON|OPTIMIZE|OPTION|OPTIONALLY|OR|ORDER|OUT|OUTER|OUTFILE|PRECISION|PRIMARY|PROCEDURE|PURGE|READ|READS|REAL|REFERENCES|REGEXP|RELEASE|RENAME|REPEAT|REPLACE|REQUIRE|RESTRICT|RETURN|REVOKE|RIGHT|RLIKE|SCHEMA|SCHEMAS|SECOND_MICROSECOND|SELECT|SENSITIVE|SEPARATOR|SET|SHOW|SMALLINT|SONAME|SPATIAL|SPECIFIC|SQL|SQLEXCEPTION|SQLSTATE|SQLWARNING|SQL_BIG_RESULT|SQL_CALC_FOUND_ROWS|SQL_SMALL_RESULT|SSL|STARTING|STRAIGHT_JOIN|TABLE|TERMINATED|THEN|TINYBLOB|TINYINT|TINYTEXT|TO|TRAILING|TRIGGER|TRUE|UNDO|UNION|UNIQUE|UNLOCK|UNSIGNED|UPDATE|USAGE|USE|USING|UTC_DATE|UTC_TIME|UTC_TIMESTAMP|VALUES|VARBINARY|VARCHAR|VARCHARACTER|VARYING|WHEN|WHERE|WHILE|WITH|WRITE|XOR|YEAR_MONTH|ZEROFILL|ASENSITIVE|CALL|CONDITION|CONNECTION|CONTINUE|CURSOR|DECLARE|DETERMINISTIC|EACH|ELSEIF|EXIT|FETCH|GOTO|INOUT|INSENSITIVE|ITERATE|LABEL|LEAVE|LOOP|MODIFIES|OUT|READS|RELEASE|REPEAT|RETURN|SCHEMA|SCHEMAS|SENSITIVE|SPECIFIC|SQL|SQLEXCEPTION|SQLSTATE|SQLWARNING|TRIGGER|UNDO|UPGRADE|WHILE");
			while($_g < $_g1->length) {
				$k = $_g1[$_g];
				++$_g;
				$h->set(strtolower($k), true);
				unset($k);
			}
		}
		return $h;
	}
}
