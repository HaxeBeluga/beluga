package beluga.resource ;

import haxe.io.Bytes;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;
import beluga.ConfigLoader;
import haxe.Resource;

using StringTools;
using beluga.tool.ExprTool;
using Lambda;

class ResourceManager
{
    #if !macro
    macro public static function register(relpath : Expr) : ExprOf<String> {
        return Context.makeExpr(register(relpath), Context.currentPos);
    }

    //Dybeluga.resource.ResourceManagerm path
    public static function dynGetStringFromPath(resource_id : String) : Null<String>{
        return  dynGetStringFromId(getId(resource_id));
    }

    public static function dynGetBytesFromPath(resource_id : String) : Null<Bytes> {
        return  dynGetBytesFromId(getId(resource_id));
    }

    public static function dynGetTplFromPath(resource_id : String) : Null<Template> {
        return  dynGetTplFromId(getId(resource_id));
    }
    
    //Dynamicly load a resource from id
    public static function dynGetStringFromId(resource_id : String) : Null<String> {
        var resource : Null<String> = null;
        if (resourceLoaded(resource_id))
            resource = haxe.Resource.getString(resource_id);
        return resource;
    }

    public static function dynGetBytesFromId(resource_id : String) : Null<Bytes> {
        var resource : Null<Bytes> = null;
        if (resourceLoaded(resource_id))
            resource = haxe.Resource.getBytes(resource_id);
        return resource;
    }

    public static function dynGetTplFromId(resource_id : String) : Null<Template> {
        var resource : Null<Template> = null;
        if (resourceLoaded(resource_id))
            resource = new haxe.Template(haxe.Resource.getString(resource_id));
        return resource;
    }
    
    #else
    
    public static function register(expr_relpath : Expr) : String {
        var relpath = expr_relpath.getCString();
        var resource_id = getId(relpath);
        if (!resourceLoaded(resource_id)) {
            var fullpath = Context.resolvePath(relpath);
            if (FileSystem.exists(fullpath) && !FileSystem.isDirectory(fullpath)) {
                Context.addResource(resource_id, File.getBytes(fullpath));                
            } else {
                Context.error(fullpath + " dont exist or is a directory", expr_relpath.pos);
            }
        }
        return resource_id;
    }

    #end
    
    //Register resource and then return expression to get it.
    macro public static function getString(expr_relpath : Expr) : Expr {
        var resource_id = register(expr_relpath);
        return macro ResourceManager.dynGetStringFromId($v { resource_id } );
    }

    macro public static function getBytes(expr_relpath : Expr) : Expr {
        var resource_id = register(expr_relpath);
        return macro ResourceManager.dynGetBytesFromId($v{resource_id});
    }

    macro public static function getTpl(expr_relpath : Expr) : Expr {
        var resource_id = register(expr_relpath);
        return macro ResourceManager.dynGetTplFromId($v{resource_id});
    }

    public static function resourceLoaded(resource_id : String) {
        return Resource.listNames().has(resource_id);
    }
    
    public static function getId(path : String) {
        return "beluga_" + path.replace("/", "_").replace("\\", "_");
    }
}