package beluga.core;

import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;
#if (!macro && php)
import php.Web;
#elseif (!macro && neko)
import neko.Web;
#elseif macro
import haxe.macro.Expr;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Context;
import tink.macro.Exprs;
#end

using tink.macro.Metadatas;
using Lambda;
using beluga.core.macro_tool.ExprUtils;
using beluga.core.macro_tool.MacroTools;

typedef TriggerData = { trigger : String, clazz : Dynamic, method : String };

/**
 * ...
 * @author Masadow
 */
class TriggerDispatcher
{
	private static var triggers = new Map < String, Array<CallbackTrigger> >();
	//
	private static var triggersList  : Array<String> = [];
	private static var staticRoutes : Array< TriggerData > = [];

	public function new()
	{
		var triggersRoutes = getStaticRoutes();
		addRoutesFromArray(triggersRoutes);
	}

	public function addRoute(trigger : String, clazz : Dynamic, method : String) {
		register( trigger, [ new CallbackTrigger(clazz, method) ] );
	}

	public function addRoutes(trigger : String, routes : Array<{clazz : Dynamic, method : String}>) {
		var callbacks = new Array<CallbackTrigger>();

		for (route in routes) {
			callbacks.push(new CallbackTrigger(route.clazz, route.method));
		}
		register(trigger, callbacks);
	}

	public function addRoutesFromFast(trigger : Fast) {
		// Retrieve trigger event
		var routes = new Array<CallbackTrigger>();

		// Get all callbacks
		for (route in trigger.nodes.route) {
			routes.push(new CallbackTrigger(route.att.resolve("class"), route.att.method));
		}
		register( trigger.att.name, routes );
	}

	private function addRoutesFromArray(triggersArray : Array<TriggerData>) {
		for (trigger in triggersArray ) {
			addRoute(trigger.trigger, trigger.clazz, trigger.method);
		}
	}

	private function register( trigger : String, routes : Array<CallbackTrigger> ) {
		var action = triggers.get(trigger);

		if (action == null) {
			triggers.set(trigger, routes);
			/* For now it's impossible to check wrong trigger at runtime since
			 * we cannot callect all dispatched triggers THEN pass it to runtime
			 */
			//throw new BelugaException("Error: trigger \"" + trigger + "\" does not exist.");
		} else {
			triggers.set(trigger, action.concat(routes));
		}
	}

	// Public but should be considered private an never used
	public function realDispatch(event : String, params : Array<Dynamic> = null) {
		if (triggers.exists(event))
			for (trigger in triggers.get(event)) {
				trigger.call(params);
			}
	}

	macro public function dispatch(ethis:ExprOf<TriggerDispatcher>, event:ExprOf<String>, params:ExprOf<Array<Dynamic>> = null):Expr {
		switch(event.expr) {
			case EConst(CString(str)):
				//url is a constant String, we can use optimized versions
				triggersList.push(str);
			default:
		}
		return macro $ethis.realDispatch($event, $params);
	}

	private static function checkTriggers():Void {
		var errors : Array<String> = [];

		for (route in staticRoutes) {
			if (triggersList.indexOf(route.trigger) == -1) {
				errors.push("Trigger \"" + route.trigger + "\" doesn't exist. Called in " + route.clazz + "." + route.method);
			}
		}
		if (errors.length != 0) {
			// format error message
			var errorMsg : String = "";
			for (error in errors) {
				errorMsg += error + "\n";
			}
			throw new BelugaException("Error: " + errorMsg);
		}
	}

	macro private static function getStaticRoutes() : Expr {
		Context.onAfterGenerate(checkTriggers);

		return Context.makeExpr(staticRoutes, Context.currentPos());
	}

	macro public static function readTriggerMetadata() : Array<Field> {
		var fields = Context.getBuildFields();

		var instanceRoutes : Array< TriggerData > = [];

		for (field in fields)
		{
			//Detect if field is static or not
			var isStatic = field.access.exists(function(access) return access == AStatic);
			//Get the meta params
			for (params in field.meta.getValues("blg_trigger")) {
				for (param in params) {
					switch (param.expr) {
						case EConst(CString(trigger)):
							(if (isStatic) staticRoutes else instanceRoutes).push({
								trigger: trigger,
								clazz  : Context.getLocalClass().get().fullClassPath(),
								method : field.name
							});
						case _:
							throw new BelugaException("Error: blg_trigger takes only type String as arguments at " + param.pos);
					}
				}
			}
		}

		//If there is a constructor, then we must overload it to register all instances in order to apply registered instanceRoutes calls to them
		var constructor = fields.find(function(field) return field.name == "new");
		if (constructor == null)
			return fields;

		//Create a field that holds instance routes
		fields.push( {
			access: [APrivate, AStatic],
			doc: null,
			kind: FVar(macro : Array<beluga.core.TriggerDispatcher.TriggerData>, macro $v{instanceRoutes}),
			meta: [],
			name: "blg_instanceRoutes",
			pos: Context.currentPos()
		});

		//register triggers at class reification
		//use of reflection to avoid naming conflict
		var registerDynamicMetadatas = macro {
			var blg_realClass = Type.resolveClass("beluga.core.Beluga");
			var blg_belugaInstance = Reflect.callMethod(blg_realClass, Reflect.field(blg_realClass, "getInstance"), null);
			var blg_triggerDispatcher = Reflect.field(blg_belugaInstance, "triggerDispatcher");
			var blg_addRoute = Reflect.field(blg_triggerDispatcher, "addRoute");
			for (route in blg_instanceRoutes) {
				//beluga.core.Beluga.getInstance().triggerDispatcher.addRoute(route.trigger, this, route.method);
				Reflect.callMethod(blg_triggerDispatcher, blg_addRoute, [route.trigger, this, route.method]);
			}
		};
		//Overload constructor
		constructor.insertInConstructor(registerDynamicMetadatas);
		return fields;
	}

	#if !macro
	public function redirect(target : String, forceHeader : Bool = true) {
		if (forceHeader) {
			Web.redirect("index.php?trigger=" + target);
		}
		else {
			dispatch(target);
		}
	}
	#end
}

private class CallbackTrigger {

	public var clazz : Dynamic;
	public var method : String;

	public function new(clazz : Dynamic, method : String) {
		this.clazz = clazz;
		this.method = method;
	}

	public function call(params : Array<Dynamic> = null) {
		if (params == null)
			params = new Array<Dynamic>();

		var realClass = clazz;
		if (Std.is(clazz, String)) {

			realClass = Type.resolveClass(clazz);
			if (realClass == null)
				throw new BelugaException("Error: class \"" + clazz + "\" can't be resolved");
		}
		Reflect.callMethod(realClass, Reflect.field(realClass, method), params);
	}
}