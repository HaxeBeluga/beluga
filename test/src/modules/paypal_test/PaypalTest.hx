package modules.paypal_test;

import beluga.module.paypal.Paypal;
import beluga.Beluga;
import haxe.http.HttpRequest;
import beluga.ConfigLoader;
import haxe.Json;

using beluga.module.paypal.RestHttp;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class PaypalTest
{

    public var beluga(default, null) : Beluga;
    public var paypal(default, null) : Paypal;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.paypal = beluga.getModuleInstance(Paypal);
        paypal.trigger.connectionFail.add(function () {
            trace("Connexion failed");
        });
    }

    public function doBuy(price : Float) {
        Web.setHeader("Content-type", "text/plain");        
        var redirect_url_base = "http://" + Web.getHostName() + ConfigLoader.getBaseUrl() + "/paypalTest/";
        var r = paypal.makeCreatePayment("Beluga Test Description", price, {
            return_url: redirect_url_base + "approveSuccess",
            cancel_url: redirect_url_base + "approveCancel"
        });
        if (r != null) {
        r.getJson({
            onData: function (response : Dynamic) {
                trace("Payment " + response.id + "  created !");
                trace(Json.stringify(response, " "));
                //To directly redirect user paypal accptance page use:
                //Web.redirect(Paypal.getApproveUrl(response));
            },
            onError: function (error : String, ?data : String) { trace("Payment creation failed ! - Error(" + error + ")"); },
            onStatus: function (code : Int) { }
        });
        } else {
            trace("Paypal authentification failed (Set paypal_conf.json file ?)");
        }
    }

    public function doApproveSuccess(args : { paymentId : String, PayerID : String, token : String }) {
        Web.setHeader("Content-type", "text/plain");
        trace("Payment " + args.paymentId + " Approved !");
        var r = paypal.makeExecutePayment(args);
        if (r != null) {
        r.getJson({
            onData: function (response : Dynamic) {
                trace("Payment " + args.paymentId + "/" + response.id + " Executed !");
            },
            onError: function (error : String, ?data : String) { trace("Payment " + args.paymentId + " Not executed =( - Error("+error+")"); },
            onStatus: function (code : Int) {}
        });
        } else {
            trace("Paypal authentification failed (Set paypal_conf.json file ?)");
        }
    }

    public function doAppoveCancel(args : { paymentId : String, PayerID : String, token : String }) {
        trace("Payment " + args.paymentId + " Not approved =( - Canceled");
    }
    
    public function doPrintConfig() {
        Web.setHeader("Content-type", "text/plain");        
        trace(Json.stringify(paypal.config, " "));
    }

}