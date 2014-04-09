package beluga.module.fileupload.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_fil_file")
@:id(fi_id)
class File extends Object {
	public var fi_id: SId;
	public var fi_id_owner: SInt;
	public var fi_name: SString<32>;
	public var fi_path: SString<32>;
	public var fi_size: SInt;
}