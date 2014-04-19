package beluga.core.macro;


import haxe.macro.Expr;
import haxe.macro.Context;

import beluga.core.macro.TestMetadata;

/**
 * ...
 * @author regnarock
 */
class TriggerMetadata
{

	macro public static function readMetadata() {
		switch (haxe.macro.Context.getType("beluga.core.macro.TestMetadata"))
		{
		  case TInst(cl, _):
			// for each field of the class
			for (field in cl.get().statics.get()) {
				switch (field.kind)
				{
				case FMethod(_):
					// for each metada of the method
					for (metadataEntry in field.meta.get()) {
						switch (metadataEntry.name)
						{
							case "trigger":
								switch (metadataEntry.params[0])
								{
									case {expr: EConst(CString(trigger)), pos: haxe.macro.Position}:
										Sys.println(field.name + " is linked to : " + trigger);
									case _:
								}
							case _:
						}
					}
				case _:
				}
			}
		  case _:
		}
		return Context.makeExpr("", Context.currentPos());
	}
	
	macro public static function getFileContent( fileName : String ) {
        return Context.makeExpr(sys.io.File.getContent(fileName),Context.currentPos());
    }

}
