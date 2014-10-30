// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core;

import beluga.core.BelugaException;
import haxe.xml.Fast;
import sys.db.Manager;
import sys.db.Connection;
import sys.db.Object;
import sys.db.TableCreate;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

class Database {
    
    private static var moduleClassTypeList : Array<ClassType> = new Array<ClassType>();

    macro public static function registerModel() : Array<Field> {
        var clazz = Context.getLocalClass().get();
        moduleClassTypeList.push(clazz);
        return Context.getBuildFields();
    }
    
    macro public static function getAllRegisteredModel() : Expr {
        var expr = new Array<Expr>();
        for (clazz in moduleClassTypeList) {
            var classIdentifier : Expr = {
                expr: EField(buildField(clazz.pack), clazz.name),
                pos: Context.currentPos()
            };
            expr.push(classIdentifier);
        }
        return {
            expr: EArrayDecl(expr),
            pos: Context.currentPos()
        }
    }
    #if macro
    
    private static function buildField(pack : Array<String>, ?index : Int) {
        if (index == null ) index = pack.length - 1;
        var expr : Expr;
        if (index > 0) {
            expr = {
                expr: EField(buildField(pack, index - 1), pack[index]),
                pos: Context.currentPos()
            }
        } else {
            expr = {
                expr: EConst(CIdent(pack[index])),
                pos: Context.currentPos()
            }
        }
        return expr;
    }
    
    #else
    public function new(cnx: Connection) {
        Manager.initialize();
        Manager.cnx = cnx;
        initRegisteredModelTable();
    }

    public static function newFromFile(dbConfig : Iterator<Fast>) {
        var dbInfo = { host: "", user: "", pass: "", database: ""};
        for (elem in dbConfig) {
            Reflect.setField(dbInfo, elem.name, elem.innerHTML);
        }
        try {
            var cnx = sys.db.Mysql.connect(dbInfo);
            return new Database(cnx);
        }
        catch (e : Dynamic) {
            throw new BelugaException("Can't connect to database");
        }
    }

    public function close() {
        sys.db.Manager.cleanup();
    }
    
    public function initRegisteredModelTable() {
        initTableList(getAllRegisteredModel());
    }

    public function initTableList(tableClassList : Array<Class<Dynamic>>) {
        for (tableClass in tableClassList) {
            dynInitTable(tableClass);
        }
    }

    public function initTable<T : sys.db.Object>(tableClass : Class<T>) {
        var t : Dynamic = tableClass;
        if (!TableCreate.exists(t.manager)){
            TableCreate.create(t.manager);
        }
    }

    public function dynInitTable(tableClass : Class<Dynamic>) {
        if (Reflect.hasField(tableClass, "manager")) {
            var manager = Reflect.field(tableClass, "manager");
            if (!TableCreate.exists(manager))
                TableCreate.create(manager);
        } else {
            throw new BelugaException("Can't create table for " + tableClass + "object. It must be sys.db.Object");
        }
    }
    #end
}
