package beluga.core.module;
import beluga.core.Beluga;
import haxe.xml.Fast;
import beluga.core.macro.ConfigLoader.ModuleConfig;

/**
 * ...
 * @author Masadow
 */
interface ModuleInternal extends Module
{
	public function _loadConfig(beluga : Beluga, config : ModuleConfig) : Void;
	public function initialize(beluga : Beluga) : Void;
}