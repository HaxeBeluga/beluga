package beluga.core;
import php.Web;

/**
 * ...
 * @author Masadow
 */
class TriggerDispatcher
{

	private var triggers : Array<Trigger>;

	public function new() 
	{
		triggers = new Array<Trigger>();
	}

	public function register(trigger : Trigger) {
		triggers.push(trigger);
	}

	public function dispatch(event : String, params : Array<Dynamic> = null) {
		for (trigger in triggers) {
			if (trigger.action == event) {
				trigger.trigger(params);
			}
		}
	}

	public function redirect(target : String, forceHeader : Bool = true) {
		if (forceHeader) {
			Web.redirect("index.php?trigger=" + target);
		}
		else {
			dispatch(target);
		}
	}
}