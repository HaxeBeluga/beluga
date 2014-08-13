package modules.account_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.ESubscribeFailCause;
import beluga.module.account.Account;
import haxe.Resource;
import main_view.Renderer;

#if php
import php.Web;
#end

/**
 * Beluga #1
 * @author Masadow
 */

class AccountTest implements MetadataReader
{

    public var beluga(default, null) : Beluga;
    public var acc(default, null) : Account;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.acc = beluga.getModuleInstance(Account);
    }

    /*
     * Logination
     */
    @bTrigger("beluga_account_login_success")
    public static function _loginSuccess(u:User) {
        new AccountTest(Beluga.getInstance()).loginSuccess();
    }

    public function loginSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Authentification succeeded !"});
        Sys.print(html);
    }

    @bTrigger("beluga_account_login_fail")
    public static function _loginFail(args : {err : String}) {
        new AccountTest(Beluga.getInstance()).loginFail(args);
    }

    public function loginFail(args : {err : String}) {
        var widget = acc.getWidget("login");
        widget.context = {error : args.err};
        var loginWidget = widget.render();
        var html = Renderer.renderDefault("page_login", "Authentification", {
            loginWidget: loginWidget
        });
        Sys.print(html);
    }

    @bTrigger("beluga_account_logout")
    public static function _logout() {
        new AccountTest(Beluga.getInstance()).logout();
    }

    public function logout() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "You're disconnected"});
        Sys.print(html);
    }

    /*
     *  Subscription
     */
    @bTrigger("beluga_account_subscribe_success")
    public static function _subscribeSuccess(user : User) {
        new AccountTest(Beluga.getInstance()).subscribeSuccess(user);
    }

    public function subscribeSuccess(user : User) {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Subscribe succeeded !"});
        Sys.print(html);
    }

    @bTrigger("beluga_account_subscribe_fail")
    public static function _subscribeFail(error : String) {
        new AccountTest(Beluga.getInstance()).subscribeFail(error);
    }

    public function subscribeFail(error : String) {
        var subscribeWidget = acc.getWidget("subscribe");

        subscribeWidget.context = {error : error};
        var html = Renderer.renderDefault("page_subscribe", "Inscription", {
            subscribeWidget: subscribeWidget.render(), error : error
        });
        Sys.print(html);
    }

    @bTrigger("beluga_account_show_user")
    public function _printCustomUserInfo(args: { id: Int }) {
        new AccountTest(Beluga.getInstance()).printCustomUserInfo(args);
    }

    @bTrigger("beluga_account_show_user")
    public function printCustomUserInfo(args: { id: Int }) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
            Sys.print(html);
            return;
        }
        var subscribeWidget = acc.getWidget("info");
        if (!user.isAdmin)
            subscribeWidget.context = {user : user, path : "/accountTest/"};
        else {
            var users = Beluga.getInstance().getModuleInstance(Account).getUsers();
            subscribeWidget.context = {user : user, path : "/accountTest/"};
        }

        var html = Renderer.renderDefault("page_subscribe", "Information", {
            subscribeWidget: subscribeWidget.render()
        });
        Sys.print(html);
    }
}