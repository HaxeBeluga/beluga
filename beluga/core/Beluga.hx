// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.PosInfos;
import haxe.Resource;
import haxe.Session;
import haxe.web.Dispatch;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import sys.db.Connection;

import beluga.core.Database;
import beluga.core.api.BelugaApi;
import beluga.core.macro.ConfigLoader;
import beluga.core.macro.ModuleLoader;
import beluga.core.FlashData;
import beluga.core.module.Module;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

using StringTools;

class Beluga {
    #if !macro
    // Keep an instance of beluga's database, read only
    public var db(default, null) : Database;
    //Instance of beluga API, read only
    public var api : BelugaApi;

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
        ModuleLoader.init();
        #if neko
        if (createSessionDirectory) {
            FileSystem.createDirectory(Web.getCwd() + "/temp");
            FileSystem.createDirectory(Web.getCwd() + "/temp/sessions");
        }
        #end
        initDatabase(cnx);
        //Create beluga API
        api = new BelugaApi();
        remotingCtx = new haxe.remoting.Context();
        
        //Compile JS assets
        beluga.core.macro.JavascriptBuilder.compile();
        //Compile CSS assets
        beluga.core.macro.CssBuilder.compile();
    }
    
    private function initDatabase(cnx) {
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
        //Init every modules
        for (module in ConfigLoader.modules) {
            var moduleInstance : Module = cast ModuleLoader.getModuleInstanceByName(module.name);
            moduleInstance._loadConfig(this, module);
        }
         for (module in ConfigLoader.modules) {
            var moduleInstance : Module = cast ModuleLoader.getModuleInstanceByName(module.name);
            moduleInstance.initialize(this);
         }
    }

    public function dispatch(defaultTrigger : String = "index") {
        var trigger = Web.getParams().get("trigger");
    }

    public function cleanup() {
        FlashData.updateTtl();
        db.close();
        Session.close(); //Very important under neko, otherwise, session is not commit and modifications may be ignored
    }

    public function getModuleInstance < T > (clazz : Class<T>, ?pos : haxe.PosInfos) : T {
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
    
    public function handleRequest() : Bool {
        var isBelugaRequest = false;
        Dispatch.run(this.getDispatchUri(), Web.getParams(), {
            doBeluga: function ( d : Dispatch) {// url: /beluga
                isBelugaRequest = true;
                d.dispatch( {
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
    #end

}
