package beluga.core.trigger;

/**
 * WARNING: Passing a Void argument as ArgType raise compilation Error see: TriggerVoid
 * @author brissa_A
 */
class Trigger<ArgType>
{
	var fctArray = new Array<{obj : Dynamic, fct : ArgType -> Void}>();

	public function new()
	{
	}

	public function addStatic(fct : ArgType -> Void) {
		fctArray.push({
			obj: null,
			fct: fct
		});
	}

	public function addMethode(obj : Dynamic, fct : ArgType -> Void) {
		fctArray.push({
			obj: obj,
			fct: fct
		});
	}
	
	public function dispatch(param : ArgType) {
		for (i in 0...fctArray.length) {
				Reflect.callMethod(fctArray[i].obj, fctArray[i].fct, [param]);
		}
	}

}

