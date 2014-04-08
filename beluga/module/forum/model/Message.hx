package beluga.module.forum.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_frm_message")
@:id(id)
@:index(user, status, tag, parent, channel)
class Message extends Object {
  public var id : SId;
  public var key : SString<12>
  public var title : SString<255>;
  public var content : SText;
  public var creation_time : STimeStamp;
  public var edition_time : Null<STimeStamp> = null;
  public var user : User;
  public var status : Status;
  public var tag : Tag;
  public var parent : Null<Message> = null;
  public var channel : Null<Channel> = null;
}