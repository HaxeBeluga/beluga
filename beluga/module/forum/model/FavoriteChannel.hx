package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_fav_chan")
@:id(id)
@:index(user, channel)
class FavoriteChannel extends Object {
  public var id : SId;
  public var channel : Channel;
  public var user : User;
}