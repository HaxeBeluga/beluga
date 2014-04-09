package beluga.module.forum.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import haxe.web.Dispatch;

import beluga.module.forum.Forum;
import beluga.module.account.model.User;

class ForumApi 
{
  var beluga : Beluga;
  var forum : Forum;

  public function new(beluga : Beluga, forum : Forum) {
    this.beluga = beluga;
    this.forum = forum;
  }

  public function doDisplayChannel(args : {
    channel_key : String
  }): Void
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_display_channel", [args]);   
  }

  public function doDisplayAddChannel(args : {
    parent_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_display_channel_add", [args]);
  }

  public function doDisplayModifyChannel(args : {
    channel_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_display_channel_modify", [args]);
  }

  public function doDisplayDeleteChannel(args : {
    channel_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_display_channel_delete", [args]);
  }

  public function doAddChannel(args : {
    label : String,
    parent_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_channel_add", [args]);
  }

  public function doModifyChannel(args : {
    label : String,
    channel_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_channel_modify", [args]);
  }

  public function doDeleteChannel(args : {
    channel_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_channel_delete", [args]);
  }

  public function doDefault()
  {
    trace("Forum default page");
  }
  
  public function doCss(d : Dispatch)
  {
    d.dispatch(new CssApi());
  }

}
