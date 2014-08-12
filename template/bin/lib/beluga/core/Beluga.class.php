<?php

class beluga_core_Beluga {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->triggerDispatcher = new beluga_core_TriggerDispatcher();
		$this->db = null;
		if(beluga_core_macro_ConfigLoader::get_config()->hasNode->resolve("database")) {
			$this->db = new beluga_core_Database(beluga_core_macro_ConfigLoader::get_config()->node->resolve("database")->get_elements());
		}
		$this->api = new beluga_core_api_BelugaApi();
		$this->api->beluga = $this;
	}}
	public $triggerDispatcher;
	public $db;
	public $api;
	public function initialize() {
		$_g = 0;
		$_g1 = beluga_core_macro_ConfigLoader::$modules;
		while($_g < $_g1->length) {
			$module = $_g1[$_g];
			++$_g;
			$moduleInstance = beluga_core_macro_ModuleLoader::getModuleInstanceByName($module->name, null);
			if($moduleInstance !== null) {
				$moduleInstance->_loadConfig($this, $module);
			}
			unset($moduleInstance,$module);
		}
	}
	public function dispatch($defaultTrigger = null) {
		if($defaultTrigger === null) {
			$defaultTrigger = "index";
		}
		$trigger = php_Web::getParams()->get("trigger");
		$this->triggerDispatcher->realDispatch((($trigger !== null) ? $trigger : $defaultTrigger), null);
	}
	public function cleanup() {
		$this->db->close();
		php_Session::close();
	}
	public function getModuleInstance($clazz, $key = null) {
		if($key === null) {
			$key = "";
		}
		return beluga_core_macro_ModuleLoader::getModuleInstanceByName(Type::getClassName($clazz), $key);
	}
	public function getDispatchUri() {
		$src = $_SERVER["SCRIPT_NAME"];
		{
			$s = php_Web::getURI();
			$sub = _hx_substr($src, 0, strlen($src) - strlen("/index.php"));
			if($sub === "") {
				return implode(str_split ($s), "");
			} else {
				return str_replace($sub, "", $s);
			}
		}
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
	static $instance = null;
	static function getInstance() {
		if(beluga_core_Beluga::$instance === null) {
			beluga_core_Beluga::$instance = new beluga_core_Beluga();
			beluga_core_Beluga::$instance->initialize();
		}
		return beluga_core_Beluga::$instance;
	}
	function __toString() { return 'beluga.core.Beluga'; }
}
