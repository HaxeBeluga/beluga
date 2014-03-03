package beluga.core.api;

import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Expr;
import beluga.core.MacroHelper;

/**
 * ...
 * @author Masadow
 */
class APIBuilder
{
	macro public static function build() : Array<Field>
	{
		var fields : Array<Field> = Context.getBuildFields();
		var pos = Context.currentPos();

		//for (module in MacroHelper.modulesArray)
		//{
			//var api : String = "beluga.module." + module.toLowerCase() + ".api." + module.charAt(0).toUpperCase() + module.substr(1) + "Api";
			//fields.push({
				//pos: pos,
				//name: "do" + module.charAt(0).toUpperCase() + module.substr(1).toLowerCase(),
				//meta: null,
				//kind: FFun( {
					//ret: null,
					//params: [],
					//expr: macro {
						//d.dispatch(new $api(beluga));
					//},
					//args: [ {
						//value: null,
						//type: macro : Dispatch,
						//opt: false,
						//name: "d"
					//}]
				//}),
				//doc: null,
				//access: [APublic, AStatic]
			//});
		//}
//
		return fields;
	}	
}