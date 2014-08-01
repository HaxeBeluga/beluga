<?php

class beluga_core_Widget {
	public function __construct($module, $name) {
		if(!php_Boot::$skip_constructor) {
		if($module !== null && $name !== null) {
			if(Lambda::has(beluga_core_Widget::$available_resources, "beluga_" . _hx_string_or_null($module) . "_" . _hx_string_or_null($name) . ".mtt")) {
				$this->filecontent = haxe_Resource::getString("beluga_" . _hx_string_or_null($module) . "_" . _hx_string_or_null($name) . ".mtt");
			} else {
				throw new HException(new beluga_core_BelugaException("The widget " . _hx_string_or_null($name) . " does not exists"));
			}
			if(Lambda::has(beluga_core_Widget::$available_resources, "beluga_" . _hx_string_or_null($module) . "_" . _hx_string_or_null($name) . ".css")) {
				$this->css = haxe_Resource::getString("beluga_" . _hx_string_or_null($module) . "_" . _hx_string_or_null($name) . ".css");
			} else {
			}
		}
		$this->context = _hx_anonymous(array());
		$this->id = 0;
		$this->html = "";
	}}
	public $context;
	public $filecontent;
	public $id;
	public $html;
	public $css;
	public function render() {
		if($this->id === 0) {
			$t = new haxe_Template("<style type=\"text/css\">::css::</style>" . _hx_string_or_null($this->filecontent));
			$this->context->_id = ++beluga_core_Widget::$last_id;
			$this->id = $this->context->id;
			if(beluga_core_macro_ConfigLoader::get_config()->hasNode->resolve("url") && beluga_core_macro_ConfigLoader::get_config()->node->resolve("url")->hasNode->resolve("base") && beluga_core_macro_ConfigLoader::get_config()->node->resolve("url")->node->resolve("base")->has->resolve("value")) {
				$this->context->base_url = beluga_core_macro_ConfigLoader::get_config()->node->resolve("url")->node->resolve("base")->att->resolve("value");
			} else {
				$this->context->base_url = "";
			}
			$this->context->css = $this->css;
			$this->html = $t->execute($this->context, null);
		}
		return $this->html;
	}
	public function getId() {
		return $this->id;
	}
	public function hclone() {
		$ret = new beluga_core_Widget(null, null);
		$ret->filecontent = $this->filecontent;
		$ret->context = $this->context;
		return $ret;
	}
	public function getCss() {
		return $this->css;
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
	static $last_id = 0;
	static $available_resources;
	function __toString() { return 'beluga.core.Widget'; }
}
beluga_core_Widget::$available_resources = haxe_Resource::listNames();
