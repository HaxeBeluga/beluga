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

class SubscribeForm extends MttWidget<Account> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/account/view/tpl/subscribe.mtt");
        super(Account, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/account/view/locale/subscribe/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var ctx = {
            loginErr: new Array<String>(),
            passwordErr: new Array<String>(),
            emailErr: new Array<String>(),
            value: mod.lastSubscribeValue,
            module_name: "Subscribe Form"
        };
        if (mod.lastSubscribeError != null) {
            //login
            if (!Validator.validate(mod.lastSubscribeError.login)) {
                var errorKeys = Validator.getErrorKeys(mod.lastSubscribeError.login);
                for (key in errorKeys) {
                    ctx.loginErr.push(BelugaI18n.getKey(i18n, "err_login_" + key));
                }
            }
            //password
            if (!Validator.validate(mod.lastSubscribeError.password)) {
                var errorKeys = Validator.getErrorKeys(mod.lastSubscribeError.password);
                for (key in errorKeys) {
                    ctx.passwordErr.push(BelugaI18n.getKey(i18n, "err_password_" + key));
                }
            }
            //email
            if (!Validator.validate(mod.lastSubscribeError.email)) {
                var errorKeys = Validator.getErrorKeys(mod.lastSubscribeError.email);
                for (key in errorKeys) {
                    ctx.emailErr.push(BelugaI18n.getKey(i18n, "err_email_" + key));
                }
            }
        }
        return ctx;
    }

}