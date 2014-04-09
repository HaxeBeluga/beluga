package beluga.module.forum.impl.channel;

import beluga.tool.IDGenerator;
import beluga.module.forum.model.Channel;

class Logic
{
  public static function add(args : {
    label : String,
    parent_key : String 
  }) : Void
  {
    var parent_chan = null;
    if (args.parent_key.length > 0)
    {
      parent_chan = Channel.manager.select($key == args.parent_key);
    }

    var channel = new Channel();
    channel.label = args.label;
    channel.key = IDGenerator.generate(12);
    channel.parent = parent_chan;

    channel.insert();
  }

  public static function modify(args : {
    label : String,
    channel_key : String
  }) : Void
  {
    var channel = Channel.manager.select($key == args.channel_key);

    channel.label = args.label;

    channel.update();
  }

  public static function delete(args : {
    channel_key : String
  }) : Void
  {
    var channel = Channel.manager.select($key == args.channel_key);

    channel.delete();
  }

  public static function addGroupAccess(args : {
    group_key : String,
    channel_key : String,
  }) : Void
  {
    
  }

  public static function removeGroupAccess(args : {
    group_key : String,
    channel_key: String,
  }) : Void
  {
    
  }

  public static function addUserAccess(args : {
    user_key : String,
    channel_key : String,
  }) : Void
  {
    
  }

  public static function removeUserAccess(args : {
    user_key : String,
    channel_key: String,
  }) : Void
  {
    
  }
}

