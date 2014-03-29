package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_frm_perm_group")
@:id(id)
@:index(group, channel)
class GroupPermission extends Object {
  public var id : SId;
  public var channel : Channel;
  public var group : UserGroup;
}