package beluga.core.macro;

import beluga.core.Beluga;
import beluga.core.TriggerDispatcher;

/**
 * ...
 * @author regnarock
 */
@:autoBuild(beluga.core.macro.MetadataBuilder.build())
class Metadata
{
	public function new()
	{
		for (metadata in getMetadata()) {
			Sys.println(metadata);
			//TODO Error handling #105
			if (metadata.name == "trigger")
				Beluga.getInstance().triggerDispatcher.addRoute(metadata.params[0], metadata.clazz, metadata.method);
		}
	}
	
	public function getMetadata(): Array < MetadataBuilder.MetadataProperties > return throw "abstract";

}