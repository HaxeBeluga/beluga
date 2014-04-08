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

  public function doLogin() {
    Web.setHeader("Content-type", "text/css");
    // Sys.print(Beluga.getInstance().getModuleInstance(Forum).getWidget("login").getCss());
  }

}