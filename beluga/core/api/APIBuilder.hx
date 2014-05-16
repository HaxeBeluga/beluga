package beluga.core.api;

import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Compiler;
import beluga.core.macro.ConfigLoader;

/**
 * ...
 * @author Masadow
 */
class APIBuilder
{
	macro public static function build() : Array<Field>
	{
		Sys.println("Generating Beluga web dispatcher API");

		var fields : Array<Field> = Context.getBuildFields();
		var pos = Context.currentPos();

		if (!ConfigLoader.isReady)
			ConfigLoader.forceBuild();

		for (module in ConfigLoader.modules)
		{
			//var api : String = "beluga.module." + module.name.toLowerCase() + ".api." + module.name.charAt(0).toUpperCase() + module.name.substr(1) + "Api";
			//new $api(beluga, cast MacroHelper.getModuleInstanceByName($v { module.name } )
			var apiDecl = {
				pos: Context.currentPos(),
				expr: ENew( {
					sub: null,
					params: [],
					pack: ["beluga", "module", module.name.toLowerCase(), "api"],
					name: module.name.charAt(0).toUpperCase() + module.name.substr(1) + "Api"
				},
				[macro beluga, macro cast ModuleLoader.getModuleInstanceByName($v{module.name})])
			};
			fields.push({
				pos: pos,
				name: "do" + module.name.charAt(0).toUpperCase() + module.name.substr(1).toLowerCase(),
				meta: null,
				kind: FFun( {
					ret: null,
					params: [],
					expr: macro {
						//Make sure temp/session exists if beluga handle session
						handleSessionPath();
						Session.start();
						d.dispatch($ { apiDecl } );
						Session.close();
					},
					args: [ {
						value: null,
						type: macro : Dispatch,
						opt: false,
						name: "d"
					}]
				}),
				doc: null,
				access: [APublic]
			});
		}

		return fields;
	}	
}