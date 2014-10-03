package beluga.module.account.rest;

import beluga.core.rest.IResource;

/**
 * ...
 * @author Masadow
 */
class UserRest implements IResource
{
    public function new() {
        
    }
    
    public function delete(?id : Int) : Dynamic {
        return "DELETE";
    }
    public function put(?id : Int) : Dynamic {
        return "PUT";
    }
    public function post(?id : Int) : Dynamic {
        return "POST";        
    }
    public function get(?id : Int) : Dynamic {
        trace("GET");
        return "GET";
    }
}
