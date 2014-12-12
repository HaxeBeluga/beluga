package modules.paypal_test;

import beluga.module.paypal.Connection;
import beluga.module.paypal.Paypal;
import beluga.Beluga;
import haxe.http.HttpRequest;

class PaypalTest
{

    public var beluga(default, null) : Beluga;
    public var paypal(default, null) : Paypal;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.paypal = beluga.getModuleInstance(Paypal);
        paypal.trigger.buyFail.add(function (id) {
            trace("Buy Failed !");
        });
        paypal.trigger.buySuccess.add(function () {
            trace("Buy success !"); 
        });
    }

    public function doBuy(price : Float) {
        paypal.quickPaypalSale("This is a buy test", price, id);
    }

    public function onError(error : String, ?data : String) {
        trace(error);
    }

}