package beluga.core;
import php.Web;

/**
 * ...
 * @author Masadow
 */
class WebDispatcher
{

	private var triggers : Array<Trigger>;

	public function new() 
	{
		triggers = new Array<Trigger>();
	}
	
	public function register(trigger : Trigger) {
		triggers.push(trigger);
	}
	
	public function dispatch(event : String) {
		for (trigger in triggers) {
			if (trigger.action == event) {
				trigger.trigger();
			}
		}
	}
	
	public function redirect(target : String, forceHeader : Bool = true) {
		if (forceHeader) {			
			Web.redirect(target);
		}
		else {
			dispatch(target);
		}
	}

}