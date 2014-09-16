package beluga.core.macro;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

typedef ModuleConfig = { name : String, path : String, tables : Array<String> };

#if !macro
@:build(beluga.core.macro.ConfigLoader.build())
#end
class ConfigLoader {
    private static var configFilePath = "beluga.xml";
    private static var built : Expr = null;
    private static var builtConfigString = "";

    public static var config(default, default) : Fast;
    public static var installPath(default, null) : String = getInstallPath();
    public static var modules(default, default) : Array<ModuleConfig>;

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
                    else if (field.name == "modules")
                        field.kind = FProp("default", "null", t, Context.makeExpr(modules, Context.currentPos()));
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
        return Context.makeExpr("DONE!", Context.currentPos());
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

    private static function loadModuleConfigurations(fast : Fast) {
        // Look for active modules
        for (module in fast.elements) {
            //Not fully supported, it can leads to mistakes
            if (module.name == "include") {
                var path : String = module.att.path;
                //Load subconfiguration
                var file = File.getContent(path);
                var xml = Xml.parse(file);
                clearForTarget(xml, getCompilationTarget());
                loadModuleConfigurations(new Fast(xml));

                //Concat the content of the xml to the main config
                builtConfigString += xml.toString();
            }
            else if (module.name == "module") {
                var name : String = module.att.name;
                var modulePath = installPath + "/module/" + name.toLowerCase();
                var module : String = "beluga.module." + name.toLowerCase();// + "." + name.substr(0, 1).toUpperCase() + name.substr(1) + "Impl";

                //Get every single models from the current module
                var tables = new Array<String>();
                if (!FileSystem.isDirectory(modulePath + "/model")) {
                    throw new BelugaException("Missing model directory from the module " + name);
                }
                else {
                    for (model in FileSystem.readDirectory(modulePath + "/model")) {
                        //Do not forget to remove the .hx extension to get the model name
                        tables.push(model.substr(0, model.length - 3));
                    }
                }

                modules.push({name: name, path: module, tables: tables});
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
        builtConfigString = File.getContent(configFilePath);
        var xml = Xml.parse(builtConfigString);
        clearForTarget(xml, getCompilationTarget());

        modules = new Array<ModuleConfig>();

        //Parse the configuration file
        loadModuleConfigurations(new Fast(xml));
        xml = Xml.parse(builtConfigString);
        clearForTarget(xml, getCompilationTarget());
        config = new Fast(xml);

        return macro "DONE!";
    }

    macro private static function getInstallPath() : Expr {
        //Call "haxelib path beluga" to get the install path of beluga
        var bytepath = new sys.io.Process("haxelib", ["path", "beluga"]).stdout.readAll();

        var path = StringTools.trim(bytepath.readString(0, bytepath.length).split("\n")[0]);

        //Check the install path of Beluga
        if (path == "") {
            throw new BelugaException("Can't locate haxe installation folder. Make sure haxe is installed through haxelib and haxelib itself is installed properly.");
        }

        return Context.makeExpr(path + "/beluga", Context.currentPos());
    }
	
	macro public static function getBaseUrl() :ExprOf<String> {
		var base_url : String;
		if (ConfigLoader.config.hasNode.url && ConfigLoader.config.node.url.hasNode.base && ConfigLoader.config.node.url.node.base.has.value)
			base_url = ConfigLoader.config.node.url.node.base.att.value;
		else
			base_url = "";
		return macro $v{base_url};
	}
}