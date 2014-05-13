package beluga.core.macro;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Type;

typedef MetadataProperties = { name : String, params : Array<String>, clazz : String, method : String };

/**
 * ...
 * @author regnarock
 */
class MetadataBuilder
{
		
	macro public static function build() : Array<Field>
	{
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		var clazz = Context.getLocalClass().get().name;

		var metadatas = new Array<MetadataProperties> ();
		for (field in fields) {
			switch (field.kind)
			{
			case FFun(fun):
				if (field.name == "testTmp") {
					Sys.println("");
					Sys.println(field);
					Sys.println("");
				}
				switch (field.access)
				{
					//metadatas only availible on static method for now
					case Lambda.exists(_, function(access) { return access == AStatic; } ) => true:
						for (metadata in field.meta) {
							var args : Array<String> = [];
							for (param in metadata.params) {
								switch (param) {
									case { expr: EConst(CString(param)), pos: _ } :
										args.push(param);
									default:
								}
							}
							metadatas.push( {
								name : metadata.name,
								params : args,
								clazz : clazz,
								method : field.name 
							} );
						}
					default:
				}
			default:
			}
		}
		/*
		var metadataPropertiesType = {
			name : "MetadataBuilder",
			pack : ["beluga", "core", "macro"],
			params : [],
			sub : "MetadataProperties"
		};
		
		var metadataPropertiesComplexeType = TPath(metadataPropertiesType);
		var metadataPropertiesArrayType = macro : Array<$metadataPropertiesComplexeType>;
		
		var retType = TPath({
			name : "Array",
			pack : [],
			params : [TPType(TPath({$metadataPropertiesArrayType}))]
		});
		*/
		fields.push( {
			pos: Context.currentPos(),
			name: "getMetadata",
			meta: [],
			kind: FFun({
				params:[],
				ret:null,
				args:[],
				expr:macro {
					return ($v{metadatas});
				}
			}),
			doc: null,
			access: [AOverride, APublic]
		});
		//switch (metadatasField) {
			//case FProp(g, s, t, e):
				//Context.getTypedExpr(type);
				//metadatasField.kind = FProp("default", "null", type, Context.makeExpr(metadatas, Context.currentPos()));
			//default:
		//}
		
		Sys.println(metadatas);
		return fields;
	}
	
	
}