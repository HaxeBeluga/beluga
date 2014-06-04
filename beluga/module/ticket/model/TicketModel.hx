package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_tic_ticket")
@:id(ti_id)
class TicketModel extends Object {
	public var ti_id: SId;
	public var ti_us_id: SInt;
	public var ti_date: SDateTime;
	public var ti_path_attachment: STinyText;
	public var ti_title: STinyText;
	public var ti_content: STinyText;
	public var ti_status: SInt;
}