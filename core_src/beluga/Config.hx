package beluga ;

import beluga.tool.DynamicTool;
using StringTools;

#if !js
import beluga.tool.JsonTool;
import sys.FileSystem;
import sys.io.File;
import haxe.macro.Compiler;
import haxe.Json;
#else
extern class JQuery extends js.JQuery {
    public static function getJSON(url : String, success : Dynamic -> Void) : Void;
}
#end
class Config
{ 
   
    macro public static function autoCreateFile(path : String) {
        if (Compiler.getDefine("no_conf") == null) {
            var realOutput = Compiler.getOutput();
            if (realOutput.endsWith(".n")) { //Trick for neko output
                realOutput = realOutput.substr(0, realOutput.lastIndexOf("/"));
            }
            if (!FileSystem.exists(realOutput + "/" + path)) {
                Sys.println(realOutput + "/" + path + " config file missing. Generating it.");
                var dir = path.substr(0, path.lastIndexOf("/"));
                FileSystem.createDirectory(realOutput + "/" + dir);
                File.saveContent(realOutput + "/" + path, "{}");
            }
        }
        return macro $v { path };
    }

    #if !js
    public static function get(path : String, ?default_conf : Dynamic) {
        var conf : Dynamic;
        if (FileSystem.exists(path)) {
            conf = JsonTool.load(path);
        } else {
            conf = {};
        }
        if (default_conf != null) {
            conf = DynamicTool.concat(default_conf, conf);
        }
        return conf;
    }
    public static function save(path : String, conf : Dynamic) {
        JsonTool.save(path, conf);
    }
    #else
    public static function get(path : String, ?default_conf : Dynamic, callback : Dynamic -> Void) {
        var jQuery = untyped q;
        jQuery.getJSON(path, function (conf : Dynamic) {
            conf = DynamicTool.concat(default_conf, conf);
            callback(conf);
        });
    }
    #end
}