package beluga.module.forum.api;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import haxe.web.Dispatch;

import beluga.module.forum.Forum;
import beluga.module.forum.model.User;

class AccountApi 
{
  var beluga : Beluga;
  var forum : Forum;

  public function new(beluga : Beluga, forum : Forum) {
    this.beluga = beluga;
    this.forum = forum;
  }

  public function doAddChannel(args : {
    label : String,
    parent_key : String 
  })
  {
    beluga.triggerDispatcher.dispatch("beluga_forum_add_channel", [args]);
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
