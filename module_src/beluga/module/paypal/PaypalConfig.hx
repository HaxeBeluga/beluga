package beluga.module.paypal;

import beluga.Config;

class PaypalConfig
{

    public static var path = Config.autoCreateFile("beluga/paypal_conf.json");

    public static var get = Config.get.bind(path, {
        url: "https://api.sandbox.paypal.com",
        client_auth {
            id:"AesL7hBTtuoL2er6JQpCxkumlftxt6-FDC_4WY_uXK62p3nvbGHEe1kxflD6",
            pwd:"EDVfmRCo0Pc8Rmcsxwpc_9fr-zFmLAMK_60iHgDoHP210PdhgXDCX4dsNxec"
        }
    });

    #if !js
    public static var save = Config.save.bind(path);
    #end
}