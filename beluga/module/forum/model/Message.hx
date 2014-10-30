package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_message")
@:id(id)
@:index(user_id, status_id, tag_id, parent_id, channel_id)
@:build(beluga.core.Database.registerModel())
class Message extends Object {
  public var id : SId;
  public var key : SString<12>;
  public var title : SString<255>;
  public var content : SText;
  public var creation_time : STimeStamp;
  public var edition_time : SNull<STimeStamp> = null;

  @:relation(user_id)
  public var user : User;

  @:relation(status_id)
  public var status : Status;

  @:relation(tag_id)
  public var tag : Tag;

  @:relation(parent_id)
  public var parent : Null<Message> = null;

  @:relation(channel_id)
  public var channel : Null<Channel> = null;
}