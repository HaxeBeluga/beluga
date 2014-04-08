package beluga.module.forum.impl;

import beluga.tool.IDGenerator;

class Channel
{
  public static function add(args : {
    label : String,
    parent_key : String 
  }) : Void
  {
    var parent_chan = null;
    if (Lambda.empty(args.parent_key) == false)
    {
      parent_chan = Channel.manager.select($key == args.parent_key);
    }

    var channel = new Channel();
    channel.label = args.label;
    channel.key = IDGenerator.generate();
    channel.parent = parent_chan;

    Channel.manager.save(channel);
  }

  public static function modify(args : {
    label : String,
    channel_key : String,
    parent_key : String 
  }) : Void;
  {
    var channel = Channel.manager.select($key == args.channel_key);

    channel.label = args.label;
    channel.parent_key = parent_key;

    Channel.manager.save(channel);
  }

  public function delete(args : {
    channel_key : String
  }) : Void
  {
    var channel = Channel.manager.select($key == args.channel_key);

    Channel.manager.delete(channel);
  }
}

