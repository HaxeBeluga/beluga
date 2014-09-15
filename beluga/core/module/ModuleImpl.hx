package beluga.core.module;

import beluga.core.Beluga;
import beluga.core.BelugaException;
import beluga.core.Widget;
import haxe.Resource;
import haxe.xml.Fast;
import sys.io.File;
import beluga.core.macro.ConfigLoader.ModuleConfig;

/**
 * ...
 * @author Masadow
 */
@:autoBuild(beluga.core.module.ModuleBuilder.build())
class ModuleImpl implements ModuleInternal
{
	//Hold the instance of the Beluga object that created this module
	private var beluga : Beluga;

	public function new() : Void
	{
	}

	public function _loadConfig(beluga : Beluga, module : ModuleConfig) : Void {
		this.beluga = beluga;

		for (table in module.tables) {
			//Initialize all module tables
			beluga.db.initTable(module.name, table);
		}
	}

	public function initialize(beluga : Beluga) : Void {
		
	}

	
	public function getWidget(name : String) : Widget {
		//First retrieve the class path
		var module = Type.getClassName(Type.getClass(this)).split(".")[2];
		return new Widget(module, name);
	}

}
