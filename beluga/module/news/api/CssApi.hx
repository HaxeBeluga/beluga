package beluga.module.news.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.news.News;

class CssApi
{

	public function new() 
	{
	}

	public function doPrint() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(News).getWidget("print_notif").getCss());
	}

	public function doDefault() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(News).getWidget("notification").getCss());
	}

}