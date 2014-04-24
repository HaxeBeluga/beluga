package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_fav_mess")
@:id(id)
@:index(user_id, message_id)
class FavoriteMessage extends Object {
  public var id : SId;

  @:relation(message_id)
  public var message : Message;

  @:relation(user_id)
  public var user : User;
}