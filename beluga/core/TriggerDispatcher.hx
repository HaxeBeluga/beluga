package beluga.core;

import beluga.core.macro.MetadataLoader;
import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;
import beluga.core.macro.ConfigLoader;

#if (!macro && php)
import php.Web;
#elseif (!macro && neko)
import neko.Web;
#elseif macro
import haxe.macro.Expr;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Context;
#end

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
	private static var triggersRoute : Array<TriggerData> = [];
	
	public function new()
	{
		var triggersRoutes = readTriggers();
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
		
		for (route in triggersRoute) {
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
	
	macro private static function readTriggers(): Expr {
		ConfigLoader.forceBuild();

		Context.onAfterGenerate(checkTriggers);

		//for (trigger in MetadataLoader.metadata.trigger) {
		//	triggersRoute.push({trigger : trigger.params[0], clazz : trigger.clazz, method : trigger.method});
		//}
		
		return Context.makeExpr(triggersRoute, Context.currentPos());
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

	private var clazz : Dynamic;
	private var method : String;

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