package beluga.module.account.rest;

import beluga.rest.Resource;

/**
 * ...
 * @author Masadow
 */
class UserRest extends Resource
{
    override public function delete(?id : Int) : Dynamic {
        return "DELETE";
    }
    override public function put(?id : Int) : Dynamic {
        return "PUT";
    }
    override public function post(?id : Int) : Dynamic {
        return "POST";        
    }
    override public function get(?id : Int) : Dynamic {
        trace(id);
        return "GET";
    }
}
