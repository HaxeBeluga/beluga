package beluga.core.trigger;

/**
 * WARNING: Passing a Void argument as ArgType raise compilation Error see: TriggerVoid
 * 
 * Improvement : Supporting methods such foo(user : User, survey : Survey) rather than foo(data : {user : User, survey : Survey});
 * To do this, you have to pass to ArgType the function args like User -> Survey instead of {user : User, survey : Survey}
 * Then, thanks to an autobuild macro, you'll be able to create on the fly the dispatch method to take the perfect amount of parameters
 * @author brissa_A
 */
//@:build(beluga.core.trigger.TriggerBuilder.build())
class Trigger<ArgType>
{
    var fctArray = new Array < ArgType -> Void > ();
	
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
