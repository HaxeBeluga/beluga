package beluga.core.trigger;

/**
 * ...
 * @author brissa_A
 */
class TriggerVoid
{
		var fctArray = new Array<Void -> Void>();

	public function new()
	{
	}

	public function add(fct : Void -> Void) {
		fctArray.push(fct);
	}

	public function dispatch() {
		for (i in 0...fctArray.length) {
			fctArray[i]();
		}
	}
}
 