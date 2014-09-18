package beluga.module.fileupload.model;

import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_fil_extension")
class Extension extends Object {
    public var id: SId;
    public var name: SString<32>;
}