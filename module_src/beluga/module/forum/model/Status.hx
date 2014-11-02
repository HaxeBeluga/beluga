package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

// Open, close...
@:table("beluga_frm_status")
@:id(id)
@:build(beluga.Database.registerModel())
class Status extends Object {
  public var id : SId;
  public var label : SString<255>;
  public var key : SString<255>;
}