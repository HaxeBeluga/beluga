// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga ;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.PosInfos;
import haxe.Resource;
import haxe.Session;
import haxe.web.Dispatch;
import haxe.xml.Fast;
import haxe.ds.ObjectMap;
import sys.io.File;
import sys.FileSystem;
import sys.db.Connection;

import beluga.Database;
import beluga.api.BelugaApi;
import beluga.ConfigLoader;
import beluga.FlashData;
import beluga.module.Module;
import beluga.module.ModuleBuilder;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

using StringTools;

class Beluga {
    #if !macro
    public var db(default, null) : Database;
    public var api(default, null) : BelugaApi;
    private var modules = new ObjectMap<Dynamic, Module>();
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
        remotingCtx = new haxe.remoting.Context();
        
        //Compile JS assets
        beluga.resource.JavascriptBuilder.compile();
        //Compile CSS assets
        beluga.resource.CssBuilder.compile();
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
     var modules = ModuleBuilder.createInstances();
        for (module in modules) {
            this.modules.set(Type.getClass(module), module);
        }
        for (module in modules) {
            module.initialize(this);
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

    public function getModuleInstance < T > (clazz : Class<T>) : T {
        return cast modules.get(cast clazz);
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
