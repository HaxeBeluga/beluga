package beluga.core.trigger;

/**
 * WARNING: Passing a Void argument as ArgType raise compilation Error see: TriggerVoid
 * @author brissa_A
 */
class Trigger<ArgType>
{
    var fctArray = new Array<ArgType -> Void>();

    public function new()
    {
    }

    public function add(fct : ArgType -> Void) {
        fctArray.push(fct);
    }

    public function dispatch(param : ArgType) {
        for (i in 0...fctArray.length) {
            fctArray[i](param);
        }
    }

}
