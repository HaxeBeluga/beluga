package modules.account_test;

import haxe.Resource;
import haxe.web.Dispatch;
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.ESubscribeFailCause;
import beluga.module.account.Account;
import modules.account_test.AccountTest;
import main_view.Renderer;

#if php
import php.Web;
#end


/**
 * ...
 * @author brissa_A
 */

class AccountTestApi {
    public var beluga(default, null) : Beluga;
    public var acc(default, null) : Account;
    public var success_msg : String;
    public var error_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.acc = beluga.getModuleInstance(Account);

        acc.triggers.deleteSuccess.add(this.deleteUserSuccess);
        acc.triggers.deleteFail.add(this.deleteUserFail);
        
        acc.triggers.banFail.add(this.banFail);
        acc.triggers.banSuccess.add(this.banSuccess);
        
        acc.triggers.unbanFail.add(this.unbanFail);
        acc.triggers.unbanSuccess.add(this.unbanSuccess);

        acc.triggers.editFail.add(this.doEditFail);
        acc.triggers.editSuccess.add(this.doEditSuccess);

        acc.triggers.blacklistFail.add(this.blacklistFail);
        acc.triggers.blacklistSuccess.add(this.blacklistSuccess);

        acc.triggers.unblacklistFail.add(this.unblacklistFail);
        acc.triggers.unblacklistSuccess.add(this.unblacklistSuccess);

        acc.triggers.friendFail.add(this.friendFail);
        acc.triggers.friendSuccess.add(this.friendSuccess);

        acc.triggers.unfriendFail.add(this.unfriendFail);
        acc.triggers.unfriendSuccess.add(this.unfriendSuccess);

        acc.triggers.defaultPage.add(this.doDefault);
    }

    public function doLoginPage() {
        var loginWidget = acc.getWidget("login");
        loginWidget.context = {error : ""};

        var html = Renderer.renderDefault("page_login", "Authentification", {
            loginWidget: loginWidget.render()
        });
        Sys.print(html);
    }

    public function doSubscribePage() {
        var subscribeWidget = acc.getWidget("subscribe").render();
        var html = Renderer.renderDefault("page_subscribe", "Inscription", {
            subscribeWidget: subscribeWidget
        });
        Sys.print(html);
    }

    public function doPrintInfo() {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "You need to be logged"});
            Sys.print(html);
            return;
        }
        var subscribeWidget = acc.getWidget("info");
        subscribeWidget.context = {user: user, path : "/accountTest/", users: this.acc.getUsers(), friends: this.acc.getFriends(user.id),
            not_friends: this.acc.getNotFriends(user.id), blacklisted: this.acc.getBlackListed(user.id), error: error_msg, success: success_msg};
        var tmp = subscribeWidget.render();

        var html = Renderer.renderDefault("page_subscribe", "Information", {
            subscribeWidget: tmp
        });
        Sys.print(html);
    }

    public function doLogout() {
        this.acc.logout();
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
        Sys.print(html);
    }

    /*@bTrigger("beluga_account_edit")
    public static function _doEdit() {
        new AccountTestApi(Beluga.getInstance()).doEdit();
    }*/

    public function doEdit() {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Please log in"});
            Sys.print(html);
            return;
        }
        var subscribeWidget = acc.getWidget("edit");
        subscribeWidget.context = {user : user, path : "/accountTest/"};

        var html = Renderer.renderDefault("page_subscribe", "Edit", {
            subscribeWidget: subscribeWidget.render()
        });
        Sys.print(html);
    }

    public function doDelete(args : {id: Int}) {
        this.acc.deleteUser(args);
    }

    public function deleteUserFail(args : {err: String}) {
        var user = this.acc.getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Please log in"});
            Sys.print(html);
            return;
        }
        var subscribeWidget = acc.getWidget("info");
        subscribeWidget.context = {user : user, path : "/accountTest/", error: args.err};

        var html = Renderer.renderDefault("page_subscribe", "Information", {
            subscribeWidget: subscribeWidget.render()
        });
        Sys.print(html);
    }

    public function deleteUserSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Your account has been deleted successfully", login: ""});
        Sys.print(html);
    }

    public function doBan(args : {id: Int}) {
        this.acc.ban(args.id);
    }

    public function banFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function banSuccess() {
        success_msg = "The user has been bannished";
        doPrintInfo();
    }

    public function doUnban(args : {id: Int}) {
        this.acc.unban(args.id);
    }

    public function unbanFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function unbanSuccess() {
        success_msg = "The user is not bannished anymore";
        doPrintInfo();
    }

    /*@bTrigger("beluga_account_save")
    public static function _doSave(args : {id: Int, email : String}) {
        new AccountTestApi(Beluga.getInstance()).doSave(args);
    }*/

    public function doSave(args : {id: Int, email : String}) {
        this.acc.edit(args.id, args.email);
    }

    public function doEditSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Email address has been changed successfully", error : ""});
        Sys.print(html);
    }

    public function doEditFail(args : {err : String}) {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : args.err});
        Sys.print(html);
    }

    public function doBlacklist(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.acc.blacklist(user.id, args.id);
        else
            doPrintInfo();
    }

    public function blacklistFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function blacklistSuccess() {
        success_msg = "The user has been blacklisted";
        doPrintInfo();
    }

    public function doUnblacklist(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.acc.unblacklist(user.id, args.id);
        else
            doPrintInfo();
    }

    public function unblacklistFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function unblacklistSuccess() {
        success_msg = "The user is not blacklisted anymore";
        doPrintInfo();
    }

    public function doFriend(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.acc.friend(user.id, args.id);
        else
            doPrintInfo();
    }

    public function friendFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function friendSuccess() {
        success_msg = "The user is now your friend";
        doPrintInfo();
    }

    public function doUnfriend(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.acc.unfriend(user.id, args.id);
        else
            doPrintInfo();
    }

    public function unfriendFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    public function unfriendSuccess() {
        success_msg = "The user is not your friend anymore";
        doPrintInfo();
    }
}