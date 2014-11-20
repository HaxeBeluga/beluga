package beluga.module.account;

/**
 * ...
 * @author Alexis Brissard
 */
class AccountConfig
{

    public static var path = Config.autoCreateFile("/beluga/account_conf.json");

    public static var get = Config.get.bind(path, {
        emailIsLogin: false
    });

}