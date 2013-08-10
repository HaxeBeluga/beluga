package beluga.core;
import haxe.xml.Fast;

/**
 * ...
 * @author Masadow
 */
class Trigger
{
	public var action(default, null) : String;
	
	private var routes : Array<CallbackTrigger>;

	public function new(trigger : Fast)
	{
		//Retrieve trigger event
		action = trigger.att.name;
		
		//Get all callback
		routes = new Array<CallbackTrigger>();
		for (route in trigger.nodes.route) {
			routes.push(new CallbackTrigger(route.att.resolve("class"), route.att.method, route.att.access == "static"));
		}
	}
	
	public function trigger() {
		for (route in routes) {
			route.call();
		}
	}

}

private class CallbackTrigger {

	private var clazz : String;
	private var method : String;
	private var isStatic : Bool;

	public function new(clazz : String, method : String, isStatic : Bool) {
		this.clazz = clazz;
		this.method = method;
		this.isStatic = isStatic;
	}
	
	public function call() {
		trace("test");
	}
}
