// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.account_test;

import haxe.Resource;
import haxe.web.Dispatch;
import beluga.Beluga;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.account.AccountErrorKind;
import modules.account_test.AccountTest;
import main_view.Renderer;

#if php
import php.Web;
#end

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
        acc.triggers.doEdit.add(this.doEdit);
    }

    public function doLoginPage() {
        var loginWidget = acc.widgets.loginForm;
        var html = Renderer.renderDefault("page_login", "Authentification", {
            loginWidget: loginWidget.render()
        });
        Sys.print(html);
    }

    public function doSubscribePage() {
        var subscribeWidget = acc.widgets.subscribeForm.render();
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
        var infoWidget = acc.widgets.info.render();
        var html = Renderer.renderDefault("page_info", "Information", {
            infoWidget: infoWidget
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

    public function doEdit() {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Please log in"});
            Sys.print(html);
            return;
        }
        var infoWidget = acc.widgets.edit.render();
        var html = Renderer.renderDefault("page_info", "Edit", {
            infoWidget: infoWidget
        });
        Sys.print(html);
    }

    public function doDelete(args : {id: Int}) {
        this.acc.deleteUser(args);
    }
    
    public function doConfig() {
        var configWidget = acc.widgets.configWidget.render();
        var html = Renderer.renderDefault("page_config", "Configuration", {
            configWidget: configWidget
        });
        Sys.print(html);
    }

    public function deleteUserFail(args : {err: AccountErrorKind}) {
        var user = this.acc.getLoggedUser();

        if (user == null) {
            var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Please log in"});
            Sys.print(html);
            return;
        }
        doPrintInfo();
    }

    public function deleteUserSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Your account has been deleted successfully", login: ""});
        Sys.print(html);
    }

    public function banFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function banSuccess() {
        //success_msg = "The user has been bannished";
        doPrintInfo();
    }

    public function unbanFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function unbanSuccess() {
        //success_msg = "The user is not bannished anymore";
        doPrintInfo();
    }

    public function doEditSuccess() {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Email address has been changed successfully", error : ""});
        Sys.print(html);
    }

    public function doEditFail(args : {err : AccountErrorKind}) {
        var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : args.err});
        Sys.print(html);
    }

    public function blacklistFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function blacklistSuccess() {
        //success_msg = "The user has been blacklisted";
        doPrintInfo();
    }

    public function unblacklistFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function unblacklistSuccess() {
        //success_msg = "The user is not blacklisted anymore";
        doPrintInfo();
    }

    public function friendFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function friendSuccess() {
        //success_msg = "The user is now your friend";
        doPrintInfo();
    }

    public function unfriendFail(args : {err: AccountErrorKind}) {
        error_msg = acc.getErrorString(args.err);
        this.doPrintInfo();
    }

    public function unfriendSuccess() {
        //success_msg = "The user is not your friend anymore";
        doPrintInfo();
    }
}