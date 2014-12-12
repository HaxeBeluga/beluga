package beluga.module.paypal;

import haxe.http.Url;
import haxe.http.HttpRequest;
#if php
import php.Web;
#elseif neko
import neko.Web;
#end

using beluga.module.paypal.RestHttp;

typedef PaypalRequestCallback = {
    ?onError : String -> ?String -> Void,
    ?onData : Connection -> Void,
    ?onStatus : Int -> Void
}

class Paypal extends Module
{
    public var trigger(default, null) : PaypalTrigger;
    public var config(default, null) : Dynamic;
    public var connection : Dynamic;
    
    private function new()
    {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        config = PaypalConfig.get();
        trigger = new PaypalTrigger();
        beluga.api.register("paypal", {
            doBuySuccess: function (?args : { paymentId : String, PayerID : String, token : String } ) {
                trigger.paymentApproved.dispatch();
            },
            doBuyFail: function () {
                trigger.paymentApproved.dispatch();
            }
        });
    }
    
    public function connect(callback) {
        if (connection != null) {
            callback();
        } else {
            var http = HttpRequest.createPostRequest(url + "/v1/oauth2/token",
            [
                {name: "grant_type", value: "client_credentials"}
            ]);
            http.headers.set("Accept", "application/json");
            http.headers.set("Accept-Language", "en_US");
            http.addBasicAuth(client_auth);
            http.getJson({
                onData: function (obj : Dynamic) {
                    var connection = obj;
                    callback();
                },
                onError: function (error : String, ?data : String) {
                    trigger.buyFail.dispatch();
                },
                onStatus: function (code : Int) { }
            });
        }
        return obj;
    }

    +public function send(uri : String, data : Dynamic, callback) {
        var http = new HttpRequest();
        http.method = "POST";
        http.url = new Url(url + uri);
        http.headers.set("Content-Type", "application/json");
        http.headers.set("Accept", "application/json");
        http.headers.set("Accept-Language", "en_US");
        http.headers.set("Authorization", "Bearer " + response.access_token);
        if (data != null) http.setJsonData(data); 
        http.getJson(callback);
    }

    public function createApprovedPayment(description : String, price : Float, id : String, currency = "EUR") {
        connect(quickPaypalSale.bind(description, price, id));
    }

    public function executePayment(paymentId) {
        connect(executePayment(description, price, id));
    }

    public function createApprovedPayment(description : String, price : Float, id : String, currency = "EUR") {
        var url = "http://" + Web.getHostName() + ConfigLoader.getBaseUrl() + "/beluga/paypal";
        send("/v1/payments/payment", {
            intent: "sale",
            redirect_urls: {
                return_url: url + "/buySuccess",
                cancel_url: url + "/buyFail"
            },
            payer: {
                payment_method: "paypal"
            },
            transactions: [
                {
                    amount:{
                        total: Std.string(price),
                        currency: currency
                    },
                    custom: id,
                    description: description
                }
            ]
        },{
            onData: function (response : Dynamic) {
                var approveLink = Lambda.find(response.links, function (link : Dynamic) {
                    return link.rel == "approval_url";
                });
                Web.redirect(approveLink.href);
            },
            onError: function (error : String, ?data : String) { paypal.trigger.buyFail.dispatch(); },
            onStatus: function (code : Int) { }
        });
    }
    
    public function executePayment(?args : { paymentId : String, PayerID : String, token : String }, id : String) {
        var url = paypal.config.url + "/v1/payments/payment/" + paymentId + "/execute/"
        send(url, null, {
            onData: paypal.trigger.paymentExecuted.dispatch(id);,
            onError: function (error : String, ?data : String) { paypal.trigger.paymentNotExecuted.dispatch(id); },
            onStatus: function (code : Int) { }
        });
    }
}
