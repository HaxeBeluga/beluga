// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core;

import haxe.Resource;
import haxe.Session;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import sys.db.Connection;

import beluga.core.module.Module;
import beluga.core.module.ModuleInternal;
import beluga.core.Database;
import beluga.core.api.BelugaApi;
import beluga.core.macro.ConfigLoader;
import beluga.core.macro.ModuleLoader;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class Beluga {
    // Keep an instance of beluga's database, read only
    public var db(default, null) : Database;
    //Instance of beluga API, read only
    public var api : BelugaApi;

    private static var instance = null;

    public static function getInstance(cnx: Connection = null) : Beluga {
        if (instance == null) {
            instance = new Beluga(cnx);
            instance.initialize();
        }
        return instance;
    }

    #if neko
    private function new(cnx: Connection  = null, createSessionDirectory : Bool = true)
    #else
    private function new(cnx: Connection = null)
    #end
    {
        #if neko
        if (createSessionDirectory) {
            FileSystem.createDirectory(Web.getCwd() + "/temp");
            FileSystem.createDirectory(Web.getCwd() + "/temp/sessions");
        }
        #end

        ModuleLoader.init();

        db = null;

        //Connect to database
        if (cnx != null) {
            db = new Database(cnx);
        } else if (ConfigLoader.config.hasNode.database) {
            db = Database.newFromFile(ConfigLoader.config.node.database.elements);
        }

        //Create beluga API
        api = new BelugaApi();
        api.beluga = this;

        //Compile JS assets
        beluga.core.macro.Javascript.compile();
        //Compile CSS assets
        beluga.core.macro.Css.compile();
    }

    //For all initialization code that require beluga's instance
    // -> called once by getInstance
    private function initialize() {
        //Init every modules
        for (module in ConfigLoader.modules) {
            var moduleInstance : ModuleInternal = cast ModuleLoader.getModuleInstanceByName(module.name);
            moduleInstance._loadConfig(this, module);
        }
         for (module in ConfigLoader.modules) {
            var moduleInstance : ModuleInternal = cast ModuleLoader.getModuleInstanceByName(module.name);
            moduleInstance.initialize(this);
         }
    }

    public function dispatch(defaultTrigger : String = "index") {
        var trigger = Web.getParams().get("trigger");
    }

    public function cleanup() {
        db.close();
        Session.close(); //Very important under neko, otherwise, session is not commit and modifications may be ignored
    }

    public function getModuleInstance < T : Module > (clazz : Class<T>) : T {
        return cast ModuleLoader.getModuleInstanceByName(Type.getClassName(clazz));
    }

    public function getDispatchUri() : String {
        #if php
        //Get the index file location
        var src : String = untyped __var__('_SERVER', 'SCRIPT_NAME');
        //Remove server subfolders from URI
        return StringTools.replace(Web.getURI(), src.substr(0, src.length - "/index.php".length), "");
        #elseif neko
        return Web.getURI();
        #end
    }
}