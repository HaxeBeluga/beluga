package beluga.module.paypal;

import haxe.http.Url;
import haxe.http.HttpRequest;

import beluga.metadata.SessionFlashData;

using beluga.module.paypal.RestHttp;

class Paypal extends Module
{
    public var trigger(default, null) : PaypalTrigger;
    public var config(default, null) : Dynamic;
    
    @:Var
    public var connection(get, null) : Dynamic;

    private function new()
    {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        config = PaypalConfig.get();
        trigger = new PaypalTrigger();
    }
    
    public function get_connection() {
        if (connection != null) {
            return connection;
        } else {
            var http = HttpRequest.createPostRequest(config.url + "/v1/oauth2/token",
            [
                {name: "grant_type", value: "client_credentials"}
            ]);
            http.headers.set("Accept", "application/json");
            http.headers.set("Accept-Language", "en_US");
            http.addBasicAuth(config.client_auth);
            http.getJson({
                onData: function (obj : Dynamic) {
                    connection = obj;
                },
                onError: function (error : String, ?data : String) {
                    trigger.connectionFail.dispatch();
                },
                onStatus: function (code : Int) { }
            });
        }
        return connection;
    }

    public function makePaypalRequest(uri : String, data : Dynamic) {
        return if (get_connection() != null) {
        var http = new HttpRequest();
        http.method = "POST";
        http.url = new Url(config.url + uri);
        http.headers.set("Content-Type", "application/json");
        http.headers.set("Accept", "application/json");
        http.headers.set("Accept-Language", "en_US");
        http.headers.set("Authorization", "Bearer " + get_connection().access_token);
        if (data != null) http.setJsonData(data); 
        http;
        } else {
            null;
        }
    }
    
    public function makeCreatePayment(description : String, price : Float, currency = "EUR", redirect_urls: {return_url : String, cancel_url : String}) {
        var url = "/v1/payments/payment";
        var data = {
            intent: "sale",
            redirect_urls:  redirect_urls,
            payer: {
                payment_method: "paypal"
            },
            transactions: [
                {
                    amount:{
                        total: Std.string(price),
                        currency: currency
                    },
                    description: description
                }
            ]
        };
        return makePaypalRequest(url, data);
    }

    public static function getApproveUrl(response : Dynamic) {
        return if (Reflect.field(response, "links") != null) {
            var approveLink = Lambda.find(response.links, function (link : Dynamic) {
                return link.rel == "approval_url";
            });
            approveLink.href;
        } else {
            throw "Paypal: request link not found";
            null;
        };
    }

    public function makeExecutePayment(?args : { paymentId : String, PayerID : String } ) {
        var url = "/v1/payments/payment/" + args.paymentId + "/execute/";
        var data = {
            payer_id: args.PayerID
        }
        return makePaypalRequest(url, data); 
    }
}
