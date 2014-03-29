package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_frm_channel")
@:id(id)
@:index(parent)
class Channel extends Object {
  public var id : SId;
  public var label : SString<255>;
  public var key : SString<255>;
  public var parent : Null<Channel> = null;
}