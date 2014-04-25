package beluga.core;

import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr;
import haxe.xml.Fast;
#if !macro
import php.Web;
#end

/**
 * ...
 * @author Masadow
 */
class TriggerDispatcher
{
	private static var triggers : Map<String, Array<CallbackTrigger> >;

	public function new() 
	{
		triggers = new Map<String, Array<CallbackTrigger> >();
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
	
	private function register( trigger : String, routes : Array<CallbackTrigger> ) {
		var action = triggers.get(trigger);

		if (action == null) {
			triggers.set(trigger, routes);
		} else {
			action.concat(routes);
		}
	}
	
	public function dispatch(event : String, params : Array<Dynamic> = null) {
		if (triggers.exists(event))
			for (trigger in triggers.get(event)) {
				trigger.call(params);
			}
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

		if (Std.is(clazz, String)) {
			clazz = Type.resolveClass(clazz);
		}
		if (clazz == null) {
			trace("Classe can't be resolved");
		} else {
			Reflect.callMethod(clazz, method, params);
		}
	}
}