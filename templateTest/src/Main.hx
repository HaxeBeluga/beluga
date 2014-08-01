package ;

import beluga.core.Beluga;
import haxe.web.Dispatch;
import php.Web;

/**
 * ...
 * @author Masadow
 */
class Main
{
	public static var beluga : Beluga;

	static function main()
	{
		beluga = Beluga.getInstance();
		Dispatch.run(Web.getParamsString(), Web.getParams(), beluga.api);
	}
	
}