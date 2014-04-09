package beluga.module.forum.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.forum.Forum;

class CssApi
{

  public function new() 
  {
    
  }

  public function doDisplayChannel() {
    Web.setHeader("Content-type", "text/css");
    Sys.print(Beluga.getInstance().getModuleInstance(Forum).getWidget("display_channel").getCss());
  }

  public function doAddChannel() {
    Web.setHeader("Content-type", "text/css");
    Sys.print(Beluga.getInstance().getModuleInstance(Forum).getWidget("add_channel").getCss());
  }

  public function doModifyChannel() {
    Web.setHeader("Content-type", "text/css");
    Sys.print(Beluga.getInstance().getModuleInstance(Forum).getWidget("modify_channel").getCss());
  }

  public function doDeleteChannel() {
    Web.setHeader("Content-type", "text/css");
    Sys.print(Beluga.getInstance().getModuleInstance(Forum).getWidget("delete_channel").getCss());
  }

}