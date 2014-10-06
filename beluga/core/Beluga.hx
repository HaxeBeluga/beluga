// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core;

import haxe.ds.ObjectMap;
import haxe.Resource;
import haxe.Session;
import haxe.web.Dispatch;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import sys.db.Connection;

import beluga.core.module.Module;
import beluga.core.module.IModule;
import beluga.core.Database;
import beluga.core.api.BelugaApi;
import beluga.core.macro.ConfigLoader;
import beluga.core.macro.ModuleLoader;
import beluga.core.FlashData;
import beluga.tool.URI;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

using StringTools;

class Beluga {
    // Keep an instance of beluga's database, read only
    public var db(default, null) : Database;
    //Instance of beluga API, read only
    public var api : BelugaApi;
    
    private var modules : ObjectMap<Dynamic, Module> = new ObjectMap<Dynamic, Module>();

    private static var instance = null;
    
    public static var remotingCtx;

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

        initDatabase(cnx);
        //Create beluga API
        api = new BelugaApi();
        api.belugaInstance = this;
        remotingCtx = new haxe.remoting.Context();

        //Compile JS assets
        beluga.core.macro.Javascript.compile();
        //Compile CSS assets
        beluga.core.macro.Css.compile();
    }
    
    inline private function initDatabase(cnx) {
        db = null;
        //Connect to database
        if (cnx != null) {
            db = new Database(cnx);
        } else if (ConfigLoader.config.hasNode.database) {
            db = Database.newFromFile(ConfigLoader.config.node.database.elements);
        }
    }
    
    
    //For all initialization code that require beluga's instance
    // -> called once by getInstance
    private function initialize() {
        var modules = cast(beluga.core.module.ModuleBuilder.buildModules(), Array<Dynamic>); //
        //Make sure all modules are registered to Beluga before initializing them, dependencies could cause serious problemes otherwise
        for (module in modules) {
            var key : Class<Dynamic> = module.ident != null ? module.ident : Type.getClass(module.instance);
            this.modules.set(key, module.instance);
            module.api.module = module.instance; //Will be available inside a Dispatch config object
            api.modules.set(Type.getClassName(key).split(".").pop().toLowerCase(), module.api);
        }
        for (module in modules) {
            module.instance.initialize(this);
        }
    }
    
    public function registerModule(module : Module, key : Class<Dynamic>) {
        modules.set(key, module);
    }

    public function cleanup() {
        FlashData.updateTtl();
        if (db != null) //Import check if the db could not setup properly
            db.close();
        Session.close(); //Very important under neko, otherwise, session is not commit and modifications may be ignored
    }

    public function getModuleInstance < T : IModule > (clazz : Class<T>) : T {
        return cast modules.get(cast clazz);
    }

    public function handleRequest() : Bool {
        var isBelugaRequest = false;
        Dispatch.run(URI.getDispatchUri(), Web.getParams(), {
            doBeluga: function ( d : Dispatch) {// url: /beluga
                isBelugaRequest = true;
                d.dispatch({
                    doRest: function (d : Dispatch) {// url: /beluga/rest
                        throw new BelugaException("Beluga Rest Api not yet supported");
                    },
                    doDefault: function(d : Dispatch) {
                        if (!haxe.remoting.HttpConnection.handleRequest(remotingCtx)) {
                              d.dispatch(api);
                        }
                    } 
                });   
            },
            doDefault: function(d : Dispatch) {
                //Let user do what he wants.
            }
        });
        return isBelugaRequest;
    }

    public static function redirect(url : String) {
        Web.redirect(url);
    }
}
