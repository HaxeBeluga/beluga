// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

#if !macro
@:build(beluga.ConfigLoader.build())
#end
class ConfigLoader {
    private static var configFilePath = "beluga.xml";
    private static var built : Expr = null;
    private static var builtConfigString = "";

    public static var config(default, default) : Fast;

    //Read only property to check if the macro has been executed or not. Useless outside of the macro context
    public static var isReady(get, never) : Bool;

    public static function get_isReady() : Bool {
        #if macro
        return built != null;
        #else
        return true;
        #end
    }

    macro public static function build() : Array<Field> {
        var fields : Array<Field> = Context.getBuildFields();

        if (!isReady)
            built = loadConfig();

        //Fill the config variables for post-macro usage
        for (field in fields) {
            switch (field.kind) {
                case FProp(g, s, t, e):
                    if (field.name == "config") {
                        field.kind = FProp("get", "null", t, null);
                    }
                default:
            }
        }

        fields.push( {
            pos: Context.currentPos(),
            name: "configStr",
            meta: [],
            kind: FVar(macro : String, macro $v{builtConfigString}),
            doc: null,
            access: [APrivate, AStatic]
        });

        return fields;
    }

    macro public static function forceBuild() : Expr {
        if (!isReady)
            built = loadConfig();
        return macro null;
    }

    //Used post macro for config prop
    #if !macro
    public static function get_config() : Fast {
        if (config == null) {
            var xml = Xml.parse(configStr);
            config = new Fast(xml);
        }

        return config;
    }
    #end

    private static function rebuildConfigFile(fast : Fast) {
         //Look for active modules
        for (module in fast.elements) {
            if (module.name == "include") {
                var path : String = module.att.path;
                //Load subconfiguration
                var file = File.getContent(path);
                var xml = Xml.parse(file);
                clearForTarget(xml, getCompilationTarget());
                rebuildConfigFile(new Fast(xml));

                //Concat the content of the xml to the main config
                builtConfigString += xml.toString();
            }
        }
    }

    macro private static function getCompilationTarget() {
        if (Context.defined("target"))
            return macro $v { Context.definedValue("target") };
        else if (Context.defined("php"))
            return macro "php";
        else if (Context.defined("neko"))
            return macro "neko";
        return macro "?";
    }

    private static function clearForTarget(xml : Xml, target : String) {
        var delArray : Array<Xml> = new Array<Xml>();
        for (child in xml.elements()) {
            var desiredTarget = child.get("if");
            if (desiredTarget != null && desiredTarget != target)
                delArray.push(child);
            else
                clearForTarget(child, target);
        }
        for (child in delArray)
            xml.removeChild(child);
    }

    macro private static function loadConfig() : Expr {
        //Load configuration
        builtConfigString = File.getContent(Context.resolvePath(configFilePath));
        var xml = Xml.parse(builtConfigString);
        clearForTarget(xml, getCompilationTarget());

        //Parse the configuration file
        rebuildConfigFile(new Fast(xml)); //Create a new builtConfigString with all included files
        
        xml = Xml.parse(builtConfigString);
        clearForTarget(xml, getCompilationTarget());
        config = new Fast(xml);

        checkConfig();

        return macro null;
    }

    macro public static function getBaseUrl() :ExprOf<String> {
        forceBuild();
    
        var base_url : String;
        if (ConfigLoader.config.hasNode.url && ConfigLoader.config.node.url.hasNode.base && ConfigLoader.config.node.url.node.base.has.value)
            base_url = ConfigLoader.config.node.url.node.base.att.value;
        else
            base_url = "";
        return macro $v{base_url};
    }

    private static function checkConfig()
    {
        if (!config.hasNode.database)
        {
            Sys.println("Warning: missing database configuration");
        }
    }
}
