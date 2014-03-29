package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_perm_user")
@:id(id)
@:index(user)
class UserPermission extends Object {
  public var id : SId;
  public var channel : Channel;
  public var user : User;
}