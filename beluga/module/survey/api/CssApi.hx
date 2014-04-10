package beluga.module.survey.api;

import php.Web;
import haxe.Resource;
import beluga.core.Beluga;
import beluga.module.survey.Survey;

class CssApi
{

	public function new() 
	{
		
	}

	public function doPrint() {
		Web.setHeader("Content-type", "text/css");
		Sys.print(Beluga.getInstance().getModuleInstance(Survey).getWidget("print").getCss());
	}
}