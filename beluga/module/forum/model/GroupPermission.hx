package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_frm_perm_group")
@:id(id)
@:index(user_group_id, channel_id)
class GroupPermission extends Object {
  public var id : SId;

  @:relation(channel_id)
  public var channel : Channel;

  @:relation(user_group_id)
  public var user_group : UserGroup;
}