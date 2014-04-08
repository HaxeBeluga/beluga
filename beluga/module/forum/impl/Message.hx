package beluga.module.forum.impl;

import beluga.module.forum.model.Status;
import beluga.module.forum.model.Tag;
import beluga.module.forum.model.Channel;
import beluga.module.forum.model.Message;
import beluga.module.account.Account;

class Message
{
  public static function add(args : {
    title : String,
    content : String,
    channel_key : String,
    status_key : String,
    tag_key : String,
    channel_key : String,
  }) : Void
  {
    var status = Status.manager.select($key == args.status_key);
    var tag = Tag.manager.select($key == args.tag_key);
    var channel = Channel.select($key == args.channel_key);

    var mess = new Message();
    mess.key = IDGenerator.generate();
    mess.title = args.title;
    mess.content = args.content;
    mess.creation_time = Date.now();
    mess.user = Beluga.getInstance().getModuleInstance(User).getLoggedUser();
    mess.status = status;
    mess.tag = tag;
    mess.parent = null;
    mess.channel = channel;

    Message.manager.save(mess);
  }

  public static function modify(args : {
    title : String,
    content : String,
    message_key : String,
    status_key : String,
    tag_key : String
  }) : Void
  {
    var mess = Message.manager.select($key == args.message_key);
    var status = Status.manager.select($key == args.status_key);
    var tag = Tag.manager.select($key == args.tag_key);

    mess.title = args.title;
    mess.content = args.content;
    mess.user = Beluga.getInstance().getModuleInstance(User).getLoggedUser();
    mess.status = status;
    mess.tag = tag;
    mess.edition_time = Date.now();

    Message.manager.save(mess);
  }

  public static function delete(args : {
    message_key : String
  }) : Void
  {
    var mess = Message.manager.select($key == args.message_key);

    Message.manager.delete(mess);
  }
}