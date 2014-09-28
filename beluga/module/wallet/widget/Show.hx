// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.widget;

import beluga.core.Beluga;
import beluga.module.account.model.User;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;
import beluga.module.account.Account;
import beluga.module.wallet.model.Currency;
import beluga.module.wallet.repository.CurrencyRepository;

import beluga.module.wallet.Wallet;

class Show extends MttWidget<WalletImpl> {

    public function new (mttfile = "beluga_wallet_show.mtt") {
        super(Wallet, mttfile);
        this.i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/locale/show/", mod.i18n);
    }

    override private function getContext() {
        var currency_repository = new CurrencyRepository();
        var user: User = null;
        var has_wallet = 1;
        var currency_name = "";
        var user_founds = 0.;
        var user_authenticated = true;

        // check if the user is logged
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            user_authenticated = false;
        } else { // get the logged user
            user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        }

        // retrieve wallet informations if the user has a wallet
        switch (mod.getUserWallet(user)) {
            case Some(wallet): {
                var site_currency = switch (currency_repository.getSiteCurrency()) {
                    case Some(c): c;
                    case None: {
                        var currency = Currency.newInit(BelugaI18n.getKey(this.i18n, "missing_currency"), 0., false);
                        currency;
                    };
                };
                has_wallet = 0;
                user_founds = site_currency.convertToCurrency(wallet.fund);
                currency_name = site_currency.name;
            };
            case None: {};
        }

        return {
            user_authenticated: user_authenticated,
            has_wallet: has_wallet,
            user: user,
            founds: user_founds,
            currency_name: currency_name
        };
    }
}