package beluga.core.macro;

import beluga.core.macro.ConfigLoader;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Context;
/**
 * ...
 * @author regnarock
 */
#if macro

typedef MetadataProperties = {params : Array<String>, clazz : String, method : String};

class MetadataLoader implements Dynamic<Array<MetadataProperties>>
{
	private static var metadatas : Map < String, Array<MetadataProperties> > = null;
	public static var metadata = new MetadataLoader();

	public function new ()
	{
	}

	public function resolve( name : String )
	{
		if (metadatas == null)
			readMetadata();
		return metadatas.get(name);
	}
	
	private static function readMetadata() {
		if (!ConfigLoader.isReady)
			ConfigLoader.forceBuild();
		metadatas = new Map<String, Array<MetadataProperties> >();
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
								var args : Array<String> = [];
								for (param in metadataEntry.params) {
									switch (param) {
										case { expr: EConst(CString(param)), pos: _ } :
											args.push(param);
										default:
									}
								}
								var newEntry = {params : args, clazz : clazz, method : field.name} ;
								if (metadatas.exists(metadataEntry.name)) {
									metadatas.get(metadataEntry.name).push(newEntry);
								} else {
									metadatas.set(metadataEntry.name, [newEntry]);
								}
							}
						default:
						}
					}
				default:
			}
			
		}

	}
}

#end