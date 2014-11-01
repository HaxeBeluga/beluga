package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_perm_user")
@:id(id)
@:index(user_id, channel_id)
@:build(beluga.Database.registerModel())
class UserPermission extends Object {
  public var id : SId;

  @:relation(channel_id)
  public var channel : Channel;

  @:relation(user_id)
  public var user : User;
}