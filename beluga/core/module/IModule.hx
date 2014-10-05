package beluga.core.module;

import beluga.core.Widget;

/**
 * ...
 * @author Masadow
 */
interface IModule
{
    public function getWidget(name : String) : Widget;
}