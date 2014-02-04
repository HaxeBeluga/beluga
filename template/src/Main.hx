package ;

import beluga.core.Beluga;
import beluga.core.BelugaApi;
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
		beluga = new Beluga();
		Dispatch.run(Web.getURI(), Web.getParams(), new BelugaApi(beluga));
	}
	
}