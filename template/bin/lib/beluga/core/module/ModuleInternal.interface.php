<?php

interface beluga_core_module_ModuleInternal extends beluga_core_module_Module{
	function _loadConfig($beluga, $config);
	function loadConfig($data);
}
