// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.api;

import beluga.rest.REST;
import beluga.module.account.rest.UserRest;
import beluga.module.faq.widget.Print;
import haxe.web.Dispatch;

import beluga.Beluga;
import beluga.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.module.config.Config;

import beluga.tool.DynamicTool;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class AccountApi  {
    public var beluga : Beluga;
    public var module : Account;

    public function new(beluga : Beluga, module : Account) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doLogin(args : {
        login : String,
        password : String,
    }) {
        module.login(args);
    }

    public function doLogout() {
        module.logout();
    }

    public function doShowUser(args: { id: Int }) {
        this.module.showUser(args);
    }

    public function doSubscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
       module.subscribe(args);
    }

    public function doDefault() {
        this.module.triggers.defaultPage.dispatch();
    }

    public function doEdit() {
        this.module.triggers.doEdit.dispatch();
    }
    
    public function doUser(d : Dispatch, ?id : Int) {
        REST.resolve(new UserRest(), id);
    }

    public function doSaveConfig() {
        try {
            beluga.getModuleInstance(Config).saveConfig(AccountConfig.get, AccountConfig.save);
            module.triggers.configSaveSuccess.dispatch();
        } catch (e : Dynamic) {
            module.triggers.configSaveFail.dispatch();            
        }
    }

    public function doBan(args : {id: Int}) {
        this.module.ban(args.id);
    }

    public function doUnban(args : {id: Int}) {
        this.module.unban(args.id);
    }

    public function doSave(args : {id: Int, email : String}) {
        this.module.edit(args.id, args.email);
    }

    public function doBlacklist(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.module.blacklist(user.id, args.id);
        else
            this.module.blacklist(-1, args.id);
    }

    public function doUnblacklist(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.module.unblacklist(user.id, args.id);
        else
            this.module.unblacklist(-1, args.id);
    }

    public function doFriend(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.module.friend(user.id, args.id);
        else
            this.module.friend(-1, args.id);
    }

    public function doUnfriend(args : {id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user != null)
            this.module.unfriend(user.id, args.id);
        else
            this.module.unfriend(-1, args.id);
    }
}
