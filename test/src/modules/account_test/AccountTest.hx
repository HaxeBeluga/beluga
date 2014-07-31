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
		acc.triggers.loginSuccess.add(this.loginSuccess);
		acc.triggers.loginInternalError.add(this.loginFail);
		acc.triggers.loginWrongPassword.add(this.loginFail);
		acc.triggers.loginValidationError.add(this.loginFail);
		
		acc.triggers.subscribeFail.add(this.subscribeFail);
		acc.triggers.subscribeSuccess.add(this.subscribeSuccess);
		
		acc.triggers.afterLogout.add(this.logout);
    }

    /*
     * Logination
     */
    public function loginSuccess() {
        var html = Renderer.renderDefault("page_login", "Authentification", {
            loginWidget: acc.widgets.loginForm.render()
        });
        Sys.print(html);
    }

    public function loginFail() {
        var html = Renderer.renderDefault("page_login", "Authentification", {
            loginWidget: acc.widgets.loginForm.render()
        });
        Sys.print(html);
    }

    public function logout() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "You're disconnected"});
        Sys.print(html);
    }

    /*
     *  Subscription
     */
    public function subscribeSuccess(args : {user : User}) {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Subscribe succeeded !"});
        Sys.print(html);
    }

    public function subscribeFail(args : {error : String}) {
        var html = Renderer.renderDefault("page_subscribe", "Inscription", {
            subscribeWidget: acc.widgets.subscribeForm.render(),
			error : args.error
        });
        Sys.print(html);
    }

    @bTrigger("beluga_account_show_user")
    public function _printCustomUserInfo(args: { id: Int }) {
        new AccountTest(Beluga.getInstance()).printCustomUserInfo(args);
    }

    @bTrigger("beluga_account_show_user")
    public function printCustomUserInfo(args: { id: Int }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
            Sys.print(html);
            return;
        }
        var subscribeWidget = acc.getWidget("info");
        subscribeWidget.context = {user : user, path : "/accountTest/"};

        var html = Renderer.renderDefault("page_subscribe", "Information", {
            subscribeWidget: subscribeWidget.render()
        });
        Sys.print(html);
    }
}