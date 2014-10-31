package beluga.trigger;

import beluga.core.Beluga;

class TriggerRedirect
{
    
    public static function redirect(t : TriggerVoid, url : String) {
        t.add(Beluga.redirect.bind(url));
    }

}
