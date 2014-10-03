package beluga.core.rest;

/**
 * ...
 * @author Masadow
 */
interface IResource
{
    public function get(?id : Int) : Dynamic;
    public function post(?id : Int) : Dynamic;
    public function put(?id : Int) : Dynamic;
    public function delete(?id : Int) : Dynamic;
    
}