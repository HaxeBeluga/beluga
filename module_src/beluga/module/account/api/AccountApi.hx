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

    public function doEdit(args : {?email : String}) {
        if (args.email != null) {
            module.edit(module.loggedUser.id, args.email);
        }
    }
    
    public function doUser(d : Dispatch, ?id : Int) {
        REST.resolve(new UserRest(), id);
    }

}
