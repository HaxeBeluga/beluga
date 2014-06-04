package beluga.core.macro_tool;

import haxe.macro.Type;

class MacroTools
{

	//Returns a human readable full class path (package + className) from a haxe.macro.ClassType
	public static function fullClassPath(classType : ClassType) : String
	{
		return (classType.pack.length > 0 ? classType.pack.join(".") + "." : "") + classType.name;
	}

}