// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.Account;
import beluga.core.macro.JsonTool;
import beluga.core.BelugaI18n;
import beluga.tool.DynamicTool;

class LoginForm extends MttWidget<AccountImpl> {

    public function new (mttfile = "beluga_account_login.mtt") {
        super(Account, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/account/view/locale/login/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var context = {
            isLogged : mod.isLogged,
            loggedUser : mod.loggedUser,
			error: null
        };
		if (mod.lastLoginError != null) {
			context.error =  BelugaI18n.getKey(i18n, "err_" + Std.string(mod.lastLoginError));
		}
        return context;
    }
}
