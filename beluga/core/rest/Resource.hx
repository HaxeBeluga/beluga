package beluga.core.rest;

/**
 * ...
 * @author Masadow
 */
class Resource
{
    public function new() {
        
    }

    public function get(?id : Int) : Dynamic { throw(new BelugaException("Invalid request type")); }
    public function post(?id : Int) : Dynamic { throw(new BelugaException("Invalid request type")); }
    public function put(?id : Int) : Dynamic { throw(new BelugaException("Invalid request type")); }
    public function delete(?id : Int) : Dynamic { throw(new BelugaException("Invalid request type")); }
}
