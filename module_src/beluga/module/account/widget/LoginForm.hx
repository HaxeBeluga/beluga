// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.account.Account;
import beluga.tool.JsonTool;
import beluga.I18n;
import beluga.tool.DynamicTool;
import beluga.widget.Layout;

class LoginForm extends MttWidget<Account> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/account/view/tpl/login.mtt");
        super(Account, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/account/view/locale/login/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var context = {
            isLogged : mod.isLogged,
            loggedUser : mod.loggedUser,
            error: null,
            module_name: "Login form"
        };
        if (mod.lastLoginError != null) {
            context.error =  BelugaI18n.getKey(i18n, "err_" + Std.string(mod.lastLoginError));
        }
        return context;
    }
}
