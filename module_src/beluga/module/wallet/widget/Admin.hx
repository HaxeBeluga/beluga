// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.widget;

import beluga.Beluga;
import beluga.I18n;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.wallet.Wallet;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.module.wallet.model.Currency;
import beluga.module.wallet.WalletErrorKind;
import beluga.module.wallet.repository.CurrencyRepository;
import beluga.widget.Layout;


class Admin extends MttWidget<Wallet> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/wallet/view/tpl/admin.mtt");
        super(Wallet, layout);
        this.i18n = BelugaI18n.loadI18nFolder("/beluga/module/ticket/view/locale/show/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var currency_repository = new CurrencyRepository();
        var user_authenticated = true;

        // Check if user is logged to display the widget, if not set the global error
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            user_authenticated = false;
        }
        // retrieve the currencys list
        var currency_list = currency_repository.getCurrencys();
        // then the site currency
        var site_currency = switch (currency_repository.getSiteCurrency()) {
            case Some(c): c;
            case None: {
                var currency = new Currency().init(BelugaI18n.getKey(this.i18n, "missing_currency"), 0., false);
                currency;
            };
        };
        return {
            user_authenticated: user_authenticated,
            error: this.realAdminError(mod.getAdminError()),
            currency_list: currency_list,
            site_currency: site_currency,
            module_name: "Wallet admin"
        };
    }

    private function realAdminError(err: WalletErrorKind): String {
        return switch (err) {
            case CurrencyDontExist: BelugaI18n.getKey(this.i18n, "currency_dont_exist");
            case CurrencyAlreadyExist: BelugaI18n.getKey(this.i18n, "currency_already_exist");
            case FieldEmpty: BelugaI18n.getKey(this.i18n, "field_empty");
            case _: null;
        };
    }
}