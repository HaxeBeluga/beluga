package beluga.core.macro;

using Lambda;

import beluga.core.BelugaException;
import beluga.core.macro.Metadata.MetadataProperties;
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
class Metadata
{
	public static var staticMetadatas = new Array<MetadataProperties>();

	macro public static function getStaticMetadatas() : Expr
	{
		return Context.makeExpr(staticMetadatas, Context.currentPos());
	}

	#if macro
	//Insert an expression at the top of a constructor block, but after a call to super() if present
	private static function insertInConstructor(constructorContent : Expr, exprToInsert : Expr) : Expr
	{
		var newBlock : Expr;
		
		switch (constructorContent) {
			case { expr: EBlock( blockContent ) }:
				var newBlockContent = blockContent.copy();
				
				switch (blockContent) {
					case blockContent[0] => { expr:ECall( { expr:EConst(CIdent("super")) }, []) } :
						newBlockContent.insert(1, exprToInsert);
					default :
						newBlockContent.insert(0, exprToInsert);
				}
				newBlockContent.iter(function(expr) expr.pos = Context.currentPos());
				newBlock = macro $b{newBlockContent};
			default:
		}
		return newBlock;
	}
	
	/*
	public static function registerTrigger(metadatas : Array<MetadataProperties>)
	{
		for (meta in metadatas)
			if (meta.name == "blg_trigger")
				beluga.core.Beluga.getInstance().triggerDispatcher.addRoute(meta.params[0], meta.clazz, meta.method);
	}
	*/
	#end
	
	//Returns a human readable package name from a haxe.macro.ClassType.pack
	private static function classPathArrayToString(classPath : Array<String>) : String
	{
		if (classPath.empty())
			return "";
		var element = classPath.shift();
		return (element + "." + classPathArrayToString(classPath));
	}
	
	//Returns a human readable full class path (package + className) from a haxe.macro.ClassType
	private static function fullClassPath(classType : haxe.macro.ClassType) : String
	{
		return classPathArrayToString(classType.pack) + classType.name;
	}
	
	macro public static function build() : Array<Field>
	{
		var fields = Context.getBuildFields();

		var dynamicMetadatas = new Array<MetadataProperties>();
		var dynamicMetadatasField : Field;
		
		for (field in fields)
		{
			for (meta in field.meta)
			{
				//Check if the meta belongs to Beluga
				if (meta.name.substr(0, 4) != "blg_")
					continue;
				//Detect if field is static or not
				var isStatic = field.access.exists(function(access) return access == AStatic);
				//Get the meta params
				var params : Array<String> = new Array<String>();
				for (param in meta.params) {
					//Supports only String for now
					switch (param) {
						case { expr: EConst(CString(param)), pos: _ }:
							params.push(param);
						default:
					}
				}
				//Create metadata properties and push into corresponding array
				var metadataProperties : MetadataProperties = {
					name   : meta.name,
					params : params,
					clazz  : fullClassPath(Context.getLocalClass().get()),
					method : field.name
				};
				if (isStatic)
					staticMetadatas.push(metadataProperties);
				else
					dynamicMetadatas.push(metadataProperties);
			}
		}
		/*
		//If there is a constructor, then we must overload it to register all instances in order to apply registered dynamicMetadata calls to them
		var constructor = fields.find(function(field) return field.name == "new");
		if (constructor != null) {
			//Create a field that holds dynamic metadatas
			fields.push( {
				access: [APrivate, AStatic],
				doc: null,
				kind: FVar(macro : Array<beluga.core.macro.Metadata.MetadataProperties>, Context.makeExpr(dynamicMetadatas, Context.currentPos())),
				meta: [],
				name: "dynamicMetadatas",
				pos: Context.currentPos()
			});
			
			//Create a field that holds class instances
			var localClassType = Context.getLocalClass().get();
			var localClassComplexType : ComplexType = TPath({
				name   : localClassType.name,
				pack   : localClassType.pack,
				params : [],
				sub    : null
			});
			fields.push( {
				access: [APrivate, AStatic],
				doc   : null,
				kind  : FVar(macro : Array<$localClassComplexType>, null),
				meta  : [],
				name  : "instances",
				pos   : Context.currentPos()
			});
		
			//Function that will register all instances of the class
			var registerInstances = macro function(ethis : $localClassComplexType, instances : Array < $localClassComplexType > ) {
				instances.push(ethis);
			} (this, instances);
			//Overload constructor
			switch (constructor.kind) {
				case FFun({args: a, expr: e, params: p, ret: r}):
					constructor.kind = FFun( {
						args  : a,
						params: p,
						ret   : r,
						expr  : insertInConstructor(e, registerInstances),
					});
				default:
			}
		}
		*/
		return fields;
	}	
	
}