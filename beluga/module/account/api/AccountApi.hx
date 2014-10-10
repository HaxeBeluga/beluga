// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.api;

import beluga.module.faq.widget.Print;
import haxe.web.Dispatch;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.core.form.Object;

class AccountApi  {
    public var beluga : Beluga;
    public var module : Account;

    public function new() {
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
    
}
