<?php

class beluga_module_account_api_AccountApi {
	public function __construct() {
		;
	}
	public $beluga;
	public $module;
	public function doLogin($args) {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_login", (new _hx_array(array($args))));
	}
	public function doLogout() {
		$this->module->logout();
	}
	public function doPrintInfo() {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_printInfo", (new _hx_array(array())));
	}
	public function doShowUser($args) {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_show_user", (new _hx_array(array($args))));
	}
	public function doSubscribe($args) {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_subscribe", (new _hx_array(array($args))));
	}
	public function doDefault() {
		haxe_Log::trace("Account default page", _hx_anonymous(array("fileName" => "AccountApi.hx", "lineNumber" => 47, "className" => "beluga.module.account.api.AccountApi", "methodName" => "doDefault")));
	}
	public function doEdit() {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_edit", (new _hx_array(array())));
	}
	public function doSave($args) {
		$this->beluga->triggerDispatcher->realDispatch("beluga_account_save", (new _hx_array(array($args))));
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
	function __toString() { return 'beluga.module.account.api.AccountApi'; }
}
