<?php

class beluga_core_TriggerDispatcher {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$triggersRoutes = (new _hx_array(array()));
		$this->addRoutesFromArray($triggersRoutes);
	}}
	public function addRoute($trigger, $clazz, $method) {
		$this->register($trigger, (new _hx_array(array(new beluga_core__TriggerDispatcher_CallbackTrigger($clazz, $method)))));
	}
	public function addRoutes($trigger, $routes) {
		$callbacks = new _hx_array(array());
		{
			$_g = 0;
			while($_g < $routes->length) {
				$route = $routes[$_g];
				++$_g;
				$callbacks->push(new beluga_core__TriggerDispatcher_CallbackTrigger($route->clazz, $route->method));
				unset($route);
			}
		}
		$this->register($trigger, $callbacks);
	}
	public function addRoutesFromFast($trigger) {
		$routes = new _hx_array(array());
		if(null == $trigger->nodes->resolve("route")) throw new HException('null iterable');
		$__hx__it = $trigger->nodes->resolve("route")->iterator();
		while($__hx__it->hasNext()) {
			$route = $__hx__it->next();
			$routes->push(new beluga_core__TriggerDispatcher_CallbackTrigger($route->att->resolve("class"), $route->att->resolve("method")));
		}
		$this->register($trigger->att->resolve("name"), $routes);
	}
	public function addRoutesFromArray($triggersArray) {
		$_g = 0;
		while($_g < $triggersArray->length) {
			$trigger = $triggersArray[$_g];
			++$_g;
			$this->addRoute($trigger->trigger, $trigger->clazz, $trigger->method);
			unset($trigger);
		}
	}
	public function register($trigger, $routes) {
		$action = beluga_core_TriggerDispatcher::$triggers->get($trigger);
		if($action === null) {
			beluga_core_TriggerDispatcher::$triggers->set($trigger, $routes);
		} else {
			$value = $action->concat($routes);
			beluga_core_TriggerDispatcher::$triggers->set($trigger, $value);
		}
	}
	public function realDispatch($event, $params = null) {
		if(beluga_core_TriggerDispatcher::$triggers->exists($event)) {
			$_g = 0;
			$_g1 = beluga_core_TriggerDispatcher::$triggers->get($event);
			while($_g < $_g1->length) {
				$trigger = $_g1[$_g];
				++$_g;
				$trigger->call($params);
				unset($trigger);
			}
		}
	}
	public function redirect($target, $forceHeader = null) {
		if($forceHeader === null) {
			$forceHeader = true;
		}
		if($forceHeader) {
			php_Web::redirect("index.php?trigger=" . _hx_string_or_null($target));
		} else {
			$this->realDispatch($target, null);
		}
	}
	static $triggers;
	static $triggersList;
	static $staticRoutes;
	static function checkTriggers() {
		$errors = (new _hx_array(array()));
		{
			$_g = 0;
			$_g1 = beluga_core_TriggerDispatcher::$staticRoutes;
			while($_g < $_g1->length) {
				$route = $_g1[$_g];
				++$_g;
				if(beluga_core_TriggerDispatcher::$triggersList->indexOf($route->trigger, null) === -1) {
					$errors->push("Trigger \"" . _hx_string_or_null($route->trigger) . "\" doesn't exist. Called in " . Std::string($route->clazz) . "." . _hx_string_or_null($route->method));
				}
				unset($route);
			}
		}
		if($errors->length !== 0) {
			$errorMsg = "";
			{
				$_g2 = 0;
				while($_g2 < $errors->length) {
					$error = $errors[$_g2];
					++$_g2;
					$errorMsg .= _hx_string_or_null($error) . "\x0A";
					unset($error);
				}
			}
			throw new HException(new beluga_core_BelugaException("Error: " . _hx_string_or_null($errorMsg)));
		}
	}
	function __toString() { return 'beluga.core.TriggerDispatcher'; }
}
beluga_core_TriggerDispatcher::$triggers = new haxe_ds_StringMap();
beluga_core_TriggerDispatcher::$triggersList = (new _hx_array(array()));
beluga_core_TriggerDispatcher::$staticRoutes = (new _hx_array(array()));
