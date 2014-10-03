package beluga.core.rest;

import beluga.core.rest.IResource;

/**
 * ...
 * @author Masadow
 */
class REST
{

    public static function resolve(resource : IResource) {
        #if neko
        var method = neko.Web.getMethod();
        #elseif php
        var method = php.Web.getMethod();
        #end
        

        switch (method)
        {
            case "GET":
                resource.get();
            case "DELETE":
                resource.delete();
            case "POST":
                resource.post();
            case "PUT":
                resource.put();
            default:
                //response = "Invalid request type";
        }        
    }
}