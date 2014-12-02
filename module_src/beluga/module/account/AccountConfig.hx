package beluga.module.account;

import beluga.Config;

class AccountConfig
{

    public static var path = Config.autoCreateFile("beluga/account_conf.json");

    public static var get = Config.get.bind(path, {
        emailIsLogin: false,
        testInt: 42,
        testFloat: 4.2,
        testString: "42"
    });

    #if !js
    public static var save = Config.save.bind(path);
    #end
}