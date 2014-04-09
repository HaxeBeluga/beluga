package beluga.core;
import haxe.xml.Fast;

enum TriggerAccess
{
	INSTANCE;
	STATIC;
}

/**
 * ...
 * @author Masadow
 */
class Trigger
{
	public var action(default, null) : String;
	
	private var routes : Array<CallbackTrigger>;

	public function new(trigger : Dynamic)
	{
		routes = new Array<CallbackTrigger>();
		if (Std.is(trigger, Fast))
		{
			var fastTrigger : Fast = cast trigger;

			//Retrieve trigger event
			action = fastTrigger.att.name;
			
			//Get all callback
			for (route in fastTrigger.nodes.route) {
				routes.push(new CallbackTrigger(route.att.resolve("class"), route.att.method, true));
			}
		}
		else
		{
			//Retrieve trigger event
			action = trigger.action;
			
			//Get all callback
			for (route in cast(trigger.route, Array<Dynamic>))
			{
				if (route.access == STATIC)
					routes.push(new CallbackTrigger(Type.getClassName(route.object), route.method, true));
				else
					routes.push(new CallbackTrigger(route.object, route.method, true));
			}
		}
	}

	public function trigger(params : Dynamic = null) {
		for (route in routes) {
			route.call(params);
		}
	}

}

private class CallbackTrigger {

	private var clazz : Dynamic;
	private var method : String;
	private var isStatic : Bool;

	public function new(clazz : Dynamic, method : String, isStatic : Bool) {
		this.clazz = clazz;
		this.method = method;
		this.isStatic = isStatic;
	}
	
	public function call(params : Array<Dynamic> = null) {
		if (params == null)
			params = new Array<Dynamic>();

		if (Std.is(clazz, String)) {
			trace(clazz);
			clazz = Type.resolveClass(clazz);
		}
		if (clazz == null) {
			trace("Classe can't be resolved");
		} else {
			Reflect.callMethod(clazz, method, params);
		}
	}
}
