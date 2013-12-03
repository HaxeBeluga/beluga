package beluga.core.module;
import haxe.xml.Fast;

/**
 * ...
 * @author Masadow
 */
interface ModuleInternal extends Module
{
	public function _loadConfig(config : String) : Void;
	public function loadConfig(data : Fast) : Void;
}