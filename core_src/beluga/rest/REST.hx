package beluga.rest ;

import beluga.BelugaException;

/**
 * ...
 * @author Masadow
 */
class REST
{

    public static function resolve(resource : Resource, ?id : Int) {
        #if neko
        var method = neko.Web.getMethod();
        #elseif php
        var method = php.Web.getMethod();
        #end

        switch (method)
        {
            case "GET":
                resource.get(id);
            case "DELETE":
                resource.delete(id);
            case "POST":
                resource.post(id);
            case "PUT":
                resource.put(id);
            default:
                throw(new BelugaException("Invalid request type"));
        }        
    }
}