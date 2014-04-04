package beluga.core.module;

#if !macro
import beluga.core.Widget;
#end

/**
 * ...
 * @author Masadow
 */
interface Module
{
	#if !macro
	public function getWidget(name : String) : Widget;
	#end
}