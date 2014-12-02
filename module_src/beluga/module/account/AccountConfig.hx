package beluga.module.account;

class AccountConfig
{

    public static var path = Config.autoCreateFile("/beluga/account_conf.json");

    public static var get = Config.get.bind(path, {
        emailIsLogin: false
    });
    
    #if !js
    public static var save = Config.save.bind(path);
    #end
}