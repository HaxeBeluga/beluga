package core;
import haxe.xml.Fast;
import sys.db.Manager;

/**
 * Contains
 * @author Masadow
 */
class Database
{

	public function new(dbConfig : Iterator<Fast>) {
		Manager.initialize();
		var dbInfo = { host: "", user: "", pass: "", database: ""};
		for (elem in dbConfig) {
			Reflect.setField(dbInfo, elem.name, elem.innerHTML);
		}
		Manager.cnx = sys.db.Mysql.connect(dbInfo);
		//Create every modules table if they do not exists
	}
	
	public function close() {
		sys.db.Manager.cleanup();
	}
	
}