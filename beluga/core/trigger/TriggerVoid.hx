package beluga.core.trigger;

/**
 * ...
 * @author brissa_A
 */
class TriggerVoid
{
	var fctArray = new Array<{obj : Dynamic, fct : Void -> Void}>();

	public function new()
	{
	}

	public function addStatic(fct : Void -> Void) {
		fctArray.push({
			obj: null,
			fct: fct
		});
	}

	public function addMethode(obj : Dynamic, fct : Void -> Void) {
		fctArray.push({
			obj: obj,
			fct: fct
		});
	}
	
	public function dispatch() {
		for (i in 0...fctArray.length) {
			Reflect.callMethod(fctArray[i].obj, fctArray[i].fct, []);
		}
	}	
}
 