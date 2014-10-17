package beluga.core.trigger;

/**
 * ...
 * @author Alexis Brissard
 */
class TriggerRedirect
{
    
    public static function redirect(t : TriggerVoid, url : String) {
        t.add(Beluga.redirect.bind(url));
    }

}
