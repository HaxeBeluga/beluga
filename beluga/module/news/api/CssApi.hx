package beluga.module.news.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.news.News;

import haxe.web.Dispatch;

class CssApi
{
	public function new() {
	}

	public function doDefault() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(News).getWidget("news").getCss());
	}

	public function doNews() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(News).getWidget("news").getCss());
	}
}