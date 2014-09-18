package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_label")
class Label extends Object {
    public var id: SId;
    public var name: SString<32>;
}