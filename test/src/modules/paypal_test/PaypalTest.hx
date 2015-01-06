package modules.paypal_test;

import beluga.module.paypal.Paypal;
import beluga.Beluga;
import haxe.http.HttpRequest;
import beluga.ConfigLoader;

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
            trace("Connexion raté !!!");
        });
    }

    public function doApproveSuccess(args : { paymentId : String, PayerID : String, token : String }) {
        //counter --;
        trace("Payment " + args.paymentId + " Approved !");
        var r = paypal.makeExecutePayment(args);
        r.getJson({
            onData: function (response : Dynamic) {
                trace("Payment " + args.paymentId + "/" + response.id + " Executed !");
            },
            onError: function (error : String, ?data : String) { trace("Payment " + args.paymentId + " Not executed =( ("+error+")"); },
            onStatus: function (code : Int) { trace(code); }
        });
    }

    public function doAppoveCancel(args : { paymentId : String, PayerID : String, token : String }) {
        trace("Payment " + args.paymentId + " Not approved =(");
    }
    
    public function doPrintConfig() {
        trace(paypal.config);
    }

    public function doBuy(price : Float) {
        var redirect_url_base = "http://" + Web.getHostName() + ConfigLoader.getBaseUrl() + "/paypalTest/";
        var r = paypal.makeCreatePayment("Je suis une description de test", 42, {
            return_url: redirect_url_base + "approveSuccess",
            cancel_url: redirect_url_base + "approveCancel"
        });
        r.getJson({
            onData: function (response : Dynamic) {
                trace("Payment " + response.id + "  created !");
                trace(response);
                trace(Paypal.getApproveUrl(response));
            },
            onError: function (error : String, ?data : String) { trace(error); },
            onStatus: function (code : Int) { }
        });
    }

    public function onError(error : String, ?data : String) {
        trace(error);
    }

}