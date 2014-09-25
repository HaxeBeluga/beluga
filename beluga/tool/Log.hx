package beluga.tool;
import beluga.core.macro.ConfigLoader;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.Template;
import sys.io.File;
import sys.io.Process;

enum LogLevel {
    WARN;
    ERROR;
    INFO;
    DEBUG;
}

typedef Debug = {
    level: LogLevel,
    message: String
};

/**
 * ...
 * @author Masadow
 */
class Log
{
    
    private static var log : Array<Debug> = [];

    public static function warn(msg : String) 
    {
        log.push({level:WARN, message:msg});
    }

    public static function error(msg : String) 
    {
        log.push({level:ERROR, message:msg});
    }
    
    public static function info(msg : String)
    {
        log.push({level:INFO, message:msg});
    }
    
    public static function debug(msg : String)
    {
        log.push({level:DEBUG, message:msg});
    }

    public static function flush()
    {
        //Filter here
        var file = getTemplate();
        var tpl = new Template(file);
        Sys.print(tpl.execute( {
            debug: log
        }));
    }

    //Get the template file
    macro public static function getTemplate()
    {
        return Context.makeExpr(File.getContent(ConfigLoader.installPath + "/tool/log.mtt"), Context.currentPos());
    }

}
