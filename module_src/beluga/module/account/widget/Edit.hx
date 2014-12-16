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
import beluga.api.form.Validator;
import beluga.I18n;
import beluga.widget.Layout;
import beluga.module.account.AccountErrorKind;

class Edit extends MttWidget<Account> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/account/view/tpl/edit.mtt");
        super(Account, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/account/view/locale/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var mod = Beluga.getInstance().getModuleInstance(Account);
        var user = mod.loggedUser;

        return {
            module_name: "Account",
            path : "/beluga/account/",
            user: user,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
        };
    }

}