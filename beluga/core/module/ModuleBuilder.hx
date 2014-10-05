// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.module;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
import beluga.core.macro.ConfigLoader;

typedef ModuleEntry = {
    type : TypePath,
    api : Expr,
    ident: Expr
};

class ModuleBuilder
{
    public static var modules : Array<ModuleEntry> = new Array<ModuleEntry>();

    //List all modules resources availables
    macro public static function listModules() : ExprOf<Array<{instance: Module, ident: Class<Dynamic>}>> {
        //Generate all declaration lines
        var modulesInstance = new Array<Expr>();
        for (module in modules) {
            var m = module.type;
            var ident = module.ident;
            modulesInstance.push(macro modules.push({
                instance: new $m(),
                ident: $ident
            }));
        }
        //Generate the final array of modules instances declaration
        return macro function () : Array<{instance: Module, ident: Class<Dynamic>}> {
            var modules = new Array<{instance: Module, ident: Class<Dynamic>}>();
            $b { modulesInstance };
            return modules;
        }();
    }
    
    #if macro
    //Load assets and src files
    private static function loadResources(module : String) : Null<String> {
        loadHtmlResources(module);
        loadCssResources(module);
        return null;
    }

    private static function loadCssResources(module : String) {
        //Check if folder exists first, if not, compile error
        var cssFolder = ConfigLoader.installPath + "/module/" + module + "/view/css/";
        if (!FileSystem.exists(cssFolder)) {
            return "The module " + module + " does not exists or is bad formatted";
        }

        for (file in FileSystem.readDirectory(cssFolder)) {
            var filepath = cssFolder + file;
            if (FileSystem.exists(filepath) && !FileSystem.isDirectory(filepath)) {
                Context.addResource("beluga_" + module + "_" + file, File.getBytes(filepath));
            }
        }
        return null;
    }

    private static function loadHtmlResources(module : String) {
        //Check if folder exists first, if not, compile error
        var tplFolder = ConfigLoader.installPath + "/module/" + module + "/view/tpl/";
        if (!FileSystem.exists(tplFolder)) {
            return "The module " + module + " does not exists or is bad formatted";
        }

        for (file in FileSystem.readDirectory(tplFolder)) {
            var filepath = tplFolder + file;
            if (FileSystem.exists(filepath) && !FileSystem.isDirectory(filepath)) {
                Context.addResource("beluga_" + module + "_" + file, File.getBytes(filepath));
            }
        }
        return null;
    }
    #end

    macro public static function build() : Array<Field>
    {
        var pos = haxe.macro.Context.currentPos();
        var fields = haxe.macro.Context.getBuildFields();

        var clazz = Context.getLocalClass().get();

        //Unsafe argument
        var err = loadResources(clazz.module.split(".")[2]);
        
        //Generate a new static instance
        var classtype : TypePath = {
            sub: null,
            params: [],
            pack: clazz.pack,
            name: clazz.name
        };
        var instance : Expr = macro new $classtype();
        fields.push( {
            pos: Context.currentPos(),
            name: "instance",
            meta: [],
            kind: FProp("default", "null", TPath(classtype), instance),
            doc: null,
            access: [APublic, AStatic]
        });
        
        var api = makeApi(classtype, fields, Context.currentPos());
        Context.defineType(api.typeDefinition);
        var apiType = api.typePath;
        
        var ident : Expr = macro null;
        
        if (clazz.meta.has(":ident")) {
            for (meta in clazz.meta.get()) {
                if (meta.name == ":ident" && meta.params.length == 1) { //Maybe throw an error if length is different from 1
                    ident = meta.params[0];
                }
            }
        }
        
        modules.push( {
            type: classtype,
            api: macro new $apiType(),
            ident: ident
        });

        if (err != null) {
            Context.error(err, Context.currentPos());
        }
        
        Sys.println("Module " + classtype.name + " loaded !");
        
        return fields;
    }
    
    private static function makeApi(from : TypePath, fields : Array<Field>, pos: Position) : Dynamic {
        
        var ct = TPath(from);
        var type : TypeDefinition = macro class Test {
            public var beluga : beluga.core.Beluga;
            public var module : $ct;
            public function new() { }
        };
        
        type.name = from.name + "Api";
        type.pack = from.pack;

        //Loop through every fields to add them to the api
        for (field in fields) {
        }
        
        return {
            typePath : {
                sub: from.sub,
                params: from.params,
                pack: from.pack,
                name: type.name
            },
            typeDefinition: type
        };
    }
}
