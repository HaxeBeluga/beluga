package beluga.module.notification.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.notification.Notification;

class CssApi
{

	public function new() 
	{
	}

	public function doPrint() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(Notification).getWidget("print_notif").getCss());
	}

	public function doDefault() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(Notification).getWidget("notification").getCss());
	}

}