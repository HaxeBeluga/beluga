package beluga.module.ticket.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_tic_message")
@:id(me_id)
class Message extends Object {
	public var me_id: SId;
	public var me_content: STinyText;
	public var me_us_id_author: SInt;
	public var me_date_creation: SDate;
	public var me_path_attachment: STinyText;
	public var me_ti_id: SInt;
}