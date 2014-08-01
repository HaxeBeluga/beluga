<?php

class php_db__PDO_PHPNativeStrategy extends php_db__PDO_TypeStrategy {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function map($data) {
		if(!isset($data["native_type"])) {
			if(isset($data["precision"])) {
				return "int";
			} else {
				return "string";
			}
		}
		$type = $data["native_type"];
		$type = strtolower($type);
		switch($type) {
		case "float":case "decimal":case "double":case "newdecimal":{
			return "float";
		}break;
		case "date":case "datetime":{
			return "date";
		}break;
		case "bool":{
			return "bool";
		}break;
		case "int":case "int24":case "int32":case "long":case "longlong":case "short":{
			return "int";
		}break;
		default:{
			return "string";
		}break;
		}
	}
	function __toString() { return 'php.db._PDO.PHPNativeStrategy'; }
}
