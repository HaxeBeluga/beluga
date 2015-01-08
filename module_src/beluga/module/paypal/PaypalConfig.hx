package beluga.module.paypal;

import beluga.Config;

class PaypalConfig
{

    public static var path = Config.autoCreateFile("beluga/paypal_conf.json");

    public static var get = Config.get.bind(path, {
        url: "https://api.sandbox.paypal.com",
        client_auth: {
            id: "paypal_id",
            pwd: "paypal_pwd",
        }
    });

    #if !js
    public static var save = Config.save.bind(path);
    #end
}