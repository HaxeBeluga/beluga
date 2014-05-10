package beluga.core.macro;

import beluga.core.macro.ConfigLoader;

/**
 * ...
 * @author regnarock
 */
class MetadataLoader
{
	private static var triggersRoute : Array<{trigger : String, clazz : Dynamic, method : String}> = null;
	
	macro public static function getMetadata() {
		if (triggersRoute != null)
			return macro triggersRoute;
		return macro readMetadata();
	}

	macro public static function readMetadata() {
		if (!ConfigLoader.isReady)
			ConfigLoader.forceBuild();
		triggersRoute = [];
		
		for (triggerClass in ConfigLoader.config.nodes.loadmetadata) {
			var clazz = triggerClass.att.resolve("class");
			
			switch (haxe.macro.Context.getType(clazz))
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
											case {expr: EConst(CString(trigger)), pos: _}:
												triggersRoute.push({trigger : trigger, clazz : clazz, method : field.name});
											default:
										}
									default:
								}
							}
						default:
						}
					}
				default:
			}
		}
		
		return Context.makeExpr(triggersRoute, Context.currentPos());
	}
}