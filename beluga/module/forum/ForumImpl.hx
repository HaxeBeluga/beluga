package beluga.module.forum;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.forum.model.Channel;

class ForumImpl extends ModuleImpl implements ForumInternal
{
  public function new()
  {
    super();
  }

  override public function loadConfig(data : Fast) 
  {

  }

  public function _addChannel(args : {
    label : String,
    parent_key : String 
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).addChannel(args);
  }

  public function addChannel(args : {
    label : String,
    parent_key : String 
  }) : Void
  {
    //////////////
    // CHECK DATA
    //////////////

    var parent_chan = null;
    if (Lambda.empty(args.parent_key) == false)
    {
      parent_chan = Channel.manager.select($key == args.parent_key);
    }

    var channel = new Channel();
    channel.label = args.label;
    channel.key = std.string(Date.now()); // change this horrible key generation !
    channel.parent = parent_chan;
    Channel.manager.save(channel);
  }

}