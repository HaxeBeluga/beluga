package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_frm_channel")
@:id(id)
@:index(parent_id)
@:build(beluga.core.Database.registerModel())
class Channel extends Object {
  public var id : SId;
  public var label : SString<255>;
  public var key : SString<255>;

  @:relation(parent_id)
  public var parent : SNull<Channel> = null;
}