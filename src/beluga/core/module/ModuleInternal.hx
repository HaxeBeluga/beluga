package beluga.core.module;
import haxe.xml.Fast;

/**
 * ...
 * @author Masadow
 */
interface ModuleInternal extends Module
{
	public function _loadConfig(path : String) : Void;
	public function loadConfig(data : Fast) : Void;
}