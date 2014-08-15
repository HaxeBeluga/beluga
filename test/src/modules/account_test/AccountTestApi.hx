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

class AccountTestApi implements MetadataReader
{
    public var beluga(default, null) : Beluga;
    public var acc(default, null) : Account;
    public var success_msg : String;
    public var error_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.acc = beluga.getModuleInstance(Account);
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

    @bTrigger("beluga_account_default")
    public static function _doDefault() {
        new AccountTestApi(Beluga.getInstance()).doDefault();
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
        Sys.print(html);
    }

    @bTrigger("beluga_account_edit")
    public static function _doEdit() {
        new AccountTestApi(Beluga.getInstance()).doEdit();
    }

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

    @bTrigger("beluga_account_delete_fail")
    public static function _deleteUserFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).deleteUserFail(args);
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

    @bTrigger("beluga_account_delete_success")
    public static function _deleteUserSuccess() {
        new AccountTestApi(Beluga.getInstance()).deleteUserSuccess();
    }

    public function deleteUserSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Your account has been deleted successfully", login: ""});
        Sys.print(html);
    }

    public function doBan(args : {id: Int}) {
        this.acc.ban(args.id);
    }

    @bTrigger("beluga_account_ban_fail")
    public static function _banFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).banFail(args);
    }

    public function banFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_ban_success")
    public static function _banSuccess() {
        new AccountTestApi(Beluga.getInstance()).banSuccess();
    }

    public function banSuccess() {
        success_msg = "The user has been bannished";
        doPrintInfo();
    }

    public function doUnban(args : {id: Int}) {
        this.acc.unban(args.id);
    }

    @bTrigger("beluga_account_unban_fail")
    public static function _unbanFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).unbanFail(args);
    }

    public function unbanFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_unban_success")
    public static function _unbanSuccess() {
        new AccountTestApi(Beluga.getInstance()).unbanSuccess();
    }

    public function unbanSuccess() {
        success_msg = "The user is not bannished anymore";
        doPrintInfo();
    }

    @bTrigger("beluga_account_save")
    public static function _doSave(args : {id: Int, email : String}) {
        new AccountTestApi(Beluga.getInstance()).doSave(args);
    }

    public function doSave(args : {id: Int, email : String}) {
        this.acc.edit(args.id, args.email);
    }

    @bTrigger("beluga_account_edit_success")
    public static function _doEditSuccess() {
        new AccountTestApi(Beluga.getInstance()).doEditSuccess();
    }

    public function doEditSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Email address has been changed successfully", error : ""});
        Sys.print(html);
    }

    @bTrigger("beluga_account_edit_fail")
    public static function _doEditFail() {
        new AccountTestApi(Beluga.getInstance()).doEditSuccess();
    }

    public function doEditFail() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Error occurred when trying to change email address"});
        Sys.print(html);
    }

    public function doBlacklist(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.acc.blacklist(user.id, args.id);
        else
            doPrintInfo();
    }

    @bTrigger("beluga_account_blacklist_fail")
    public static function _blacklistFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).blacklistFail(args);
    }

    public function blacklistFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_blacklist_success")
    public static function _blacklistSuccess() {
        new AccountTestApi(Beluga.getInstance()).blacklistSuccess();
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

    @bTrigger("beluga_account_unblacklist_fail")
    public static function _unblacklistFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).unblacklistFail(args);
    }

    public function unblacklistFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_unblacklist_success")
    public static function _unblacklistSuccess() {
        new AccountTestApi(Beluga.getInstance()).unblacklistSuccess();
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

    @bTrigger("beluga_account_friend_fail")
    public static function _friendFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).friendFail(args);
    }

    public function friendFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_friend_success")
    public static function _friendSuccess() {
        new AccountTestApi(Beluga.getInstance()).friendSuccess();
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

    @bTrigger("beluga_account_unfriend_fail")
    public static function _unfriendFail(args : {err: String}) {
        new AccountTestApi(Beluga.getInstance()).unfriendFail(args);
    }

    public function unfriendFail(args : {err: String}) {
        error_msg = args.err;
        this.doPrintInfo();
    }

    @bTrigger("beluga_account_unfriend_success")
    public static function _unfriendSuccess() {
        new AccountTestApi(Beluga.getInstance()).unfriendSuccess();
    }

    public function unfriendSuccess() {
        success_msg = "The user is not your friend anymore";
        doPrintInfo();
    }
}