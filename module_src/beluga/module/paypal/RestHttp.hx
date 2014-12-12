package beluga.module.paypal;

import haxe.http.HttpRequest;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Json;

typedef AuthInfo = { id : String, pwd : String };

class RestHttp
{

    public static function addBasicAuth(http : HttpRequest, auth : AuthInfo) {
        var encoded = Base64.encode(Bytes.ofString(auth.id + ":" + auth.pwd));
        http.headers.set("Authorization", "Basic " + encoded);
    }

    public static function getJson(http : HttpRequest, callback : {
        ?onError : String -> ?String -> Void,
        ?onData : Dynamic -> Void,
        ?onStatus : Int -> Void
    })
    {
        http.send( {
            onData: function (json : String) {
                var obj = Json.parse(json);
                callback.onData(obj);
            },
            onError: callback.onError,
            onStatus: callback.onStatus
        });
    }

    public static function setJsonData(http : HttpRequest, value : Dynamic) {
        http.data = Json.stringify(value);
    }

} 