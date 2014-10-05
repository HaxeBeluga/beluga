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
import sys.db.TableCreate;
import beluga.core.macro.ModuleLoader;

class Database {

    public function new(cnx: Connection) {
        Manager.initialize();
        Manager.cnx = cnx;
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

    public function initTable(tableClass : Class<Dynamic>) {
//        var tableClass = ModuleLoader.resolveModel(module, table);

        if (Reflect.hasField(tableClass, "manager")) {
            var manager = Reflect.field(tableClass, "manager");
            if (!TableCreate.exists(manager))
                TableCreate.create(manager);
        }
        else
            throw new BelugaException(tableClass + " is not a valid database object");
    }

    public function close() {
        sys.db.Manager.cleanup();
    }
}