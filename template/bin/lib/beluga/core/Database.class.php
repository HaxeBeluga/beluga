<?php

class beluga_core_Database {
	public function __construct($dbConfig) { if(!php_Boot::$skip_constructor) {
		sys_db_Manager::initialize();
		$dbInfo = _hx_anonymous(array("host" => "", "user" => "", "pass" => "", "database" => ""));
		$__hx__it = $dbConfig;
		while($__hx__it->hasNext()) {
			$elem = $__hx__it->next();
			$field = $elem->get_name();
			$value = $elem->get_innerHTML();
			$dbInfo->{$field} = $value;
			unset($value,$field);
		}
		sys_db_Manager::set_cnx(sys_db_Mysql::connect($dbInfo));
	}}
	public function initTable($module, $table) {
		$tableClass = beluga_core_macro_ModuleLoader::resolveModel($module, $table);
		if(_hx_has_field($tableClass, "manager")) {
			$manager = Reflect::field($tableClass, "manager");
			if(!sys_db_TableCreate::exists($manager)) {
				sys_db_TableCreate::create($manager, null);
			}
		} else {
			throw new HException(new beluga_core_BelugaException(_hx_string_or_null($table) . " is not a valid database object"));
		}
	}
	public function close() {
		sys_db_Manager::cleanup();
	}
	function __toString() { return 'beluga.core.Database'; }
}
