package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

// Post-it, question....
@:table("beluga_frm_tag")
@:id(id)
class Tag extends Object {
  public var id : SId;
  public var label : SString<255>;
  public var key : SString<255>;
}