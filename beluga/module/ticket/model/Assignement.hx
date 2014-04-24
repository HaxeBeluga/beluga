package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_tic_assignement")
@:id(as_id)
class Assignement extends Object {
	public var as_id: SId;
	public var as_us_id: SInt;
	public var as_ti_id: SInt;
}