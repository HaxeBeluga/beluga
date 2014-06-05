package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_tic_label")
@:id(la_id)
class Label extends Object {
    public var la_id: SId;
    public var la_name: SString<32>;
}