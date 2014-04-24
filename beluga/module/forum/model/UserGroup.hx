package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_usergroup")
@:id(id)
@:index(user_id, group_id)
class UserGroup extends Object {
  public var id : SId;

  @:relation(group_id)
  public var group : Group;

  @:relation(user_id)
  public var user : User;
}