package beluga.core ;

import haxe.Session;

class FlashData
{
    private static function getFlashDataMap() : Map<String, {value : Dynamic, ttl : Int}> {
        if (Session.get("__flashdata__") == null) {
            Session.set("__flashdata__", new Map<String, {value : Dynamic, ttl : Int}>());
        }
        return cast Session.get("__flashdata__");
    }
    public static function set(key : String, value : Dynamic, ttl = 1) {
        getFlashDataMap().set(key, { value: value, ttl: ttl } );
    }

    public static function get(key : String) {
        var data = getFlashDataMap().get(key);
        return data != null ? data.value : null;
    }
    
    public static function remove(key : String) {
        getFlashDataMap().remove(key);
    }
    
    public static function updateTtl() {
        var flashDataMap = getFlashDataMap();
        for (key in flashDataMap.keys()) {
            var data = flashDataMap.get(key);
            data.ttl -= 1;
            if (data.ttl < 0) {
               flashDataMap.remove(key);
            }
        }
    }
}