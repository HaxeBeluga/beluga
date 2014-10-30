package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_fav_chan")
@:id(id)
@:index(user_id, channel_id)
@:build(beluga.core.Database.registerModel())
class FavoriteChannel extends Object {
  public var id : SId;

  @:relation(user_id)
  public var user : User;

  @:relation(channel_id)
  public var channel : Channel;
}