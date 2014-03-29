package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_usergroup")
@:id(id)
@:index(user, group)
class UserGroup extends Object {
  public var id : SId;
  public var group : Group;
  public var user : User;
}