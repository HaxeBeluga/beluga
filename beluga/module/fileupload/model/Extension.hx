package beluga.module.fileupload.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_fil_extension")
@:id(ex_id)
class Extension extends Object {
	public var ex_id: SId;
	public var ex_name: SString<32>;
}