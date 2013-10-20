package beluga.core.module;
import beluga.core.Widget;

/**
 * ...
 * @author Masadow
 */
interface Module
{
	public function getWidget(name : String) : Widget;
}