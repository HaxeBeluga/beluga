<?php

class beluga_core_macro_ConfigLoader {
	public function __construct(){}
	static $configFilePath = "beluga.xml";
	static $built = null;
	static $builtConfigString = "";
	static $config;
	static $installPath = "/home/imperio/haxe/Beluga//beluga";
	static $modules;
	static function get_isReady() {
		return true;
	}
	static function get_config() {
		if(beluga_core_macro_ConfigLoader::$config === null) {
			$xml = Xml::parse(beluga_core_macro_ConfigLoader::$configStr);
			beluga_core_macro_ConfigLoader::$config = new haxe_xml_Fast($xml);
		}
		return beluga_core_macro_ConfigLoader::$config;
	}
	static function loadModuleConfigurations($fast) {
		if(null == $fast) throw new HException('null iterable');
		$__hx__it = $fast->get_elements();
		while($__hx__it->hasNext()) {
			$module = $__hx__it->next();
			if($module->get_name() === "include") {
				$path = $module->att->resolve("path");
				$file = sys_io_File::getContent($path);
				$xml = Xml::parse($file);
				beluga_core_macro_ConfigLoader::clearForTarget($xml, "php");
				beluga_core_macro_ConfigLoader::loadModuleConfigurations(new haxe_xml_Fast($xml));
				beluga_core_macro_ConfigLoader::$builtConfigString .= _hx_string_or_null($xml->toString());
				unset($xml,$path,$file);
			} else {
				if($module->get_name() === "module") {
					$name = $module->att->resolve("name");
					$modulePath = _hx_string_or_null(beluga_core_macro_ConfigLoader::$installPath) . "/module/" . _hx_string_or_null(strtolower($name));
					$module1 = "beluga.module." . _hx_string_or_null(strtolower($name));
					$config = sys_io_File::getContent(_hx_string_or_null(beluga_core_macro_ConfigLoader::$installPath) . "/module/" . _hx_string_or_null(strtolower($name)) . "/config.xml");
					$tables = new _hx_array(array());
					if(!is_dir(_hx_string_or_null($modulePath) . "/model")) {
						throw new HException(new beluga_core_BelugaException("Missing model directory from the module " . _hx_string_or_null($name)));
					} else {
						$_g = 0;
						$_g1 = sys_FileSystem::readDirectory(_hx_string_or_null($modulePath) . "/model");
						while($_g < $_g1->length) {
							$model = $_g1[$_g];
							++$_g;
							$tables->push(_hx_substr($model, 0, strlen($model) - 3));
							unset($model);
						}
						unset($_g1,$_g);
					}
					beluga_core_macro_ConfigLoader::$modules->push(_hx_anonymous(array("name" => $name, "path" => $module1, "config" => $config, "tables" => $tables)));
					unset($tables,$name,$modulePath,$module1,$config);
				}
			}
		}
	}
	static function clearForTarget($xml, $target) {
		$delArray = new _hx_array(array());
		if(null == $xml) throw new HException('null iterable');
		$__hx__it = $xml->elements();
		while($__hx__it->hasNext()) {
			$child = $__hx__it->next();
			$desiredTarget = $child->get("if");
			if($desiredTarget !== null && $desiredTarget !== $target) {
				$delArray->push($child);
			} else {
				beluga_core_macro_ConfigLoader::clearForTarget($child, $target);
			}
			unset($desiredTarget);
		}
		{
			$_g = 0;
			while($_g < $delArray->length) {
				$child1 = $delArray[$_g];
				++$_g;
				$xml->removeChild($child1);
				unset($child1);
			}
		}
	}
	static $configStr = "";
	static $__properties__ = array("get_isReady" => "get_isReady","get_config" => "get_config");
	function __toString() { return 'beluga.core.macro.ConfigLoader'; }
}
beluga_core_macro_ConfigLoader::$modules = (new _hx_array(array()));
