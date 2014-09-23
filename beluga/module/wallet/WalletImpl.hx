// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet;

// Haxe
import haxe.xml.Fast;
import haxe.ds.Option;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;
import beluga.core.BelugaI18n;

// Beluga mods
import beluga.module.wallet.model.Currency;
import beluga.module.wallet.model.SiteCurrency;
import beluga.module.wallet.model.WalletModel;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.wallet.WalletErrorKind;

class WalletImpl extends ModuleImpl implements WalletInternal {
    public var triggers = new WalletTrigger();
    public var widgets: WalletWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/module/wallet/local/");
    var admin_error: WalletErrorKind = None;
    // two error for user widget
    var user_authenticated = true;

    // ID of the unique field of SiteCurrency
    public static var WEBSITE_ID = 1;

    public function new() { super(); }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new WalletWidget();
    }

    // pages

    public function create(): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.user_authenticated = false;
            this.triggers.creationFail.dispatch();
        } else { // get the logged user
            var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
            var wallet = new WalletModel();
            wallet.user_id = user.id;
            wallet.fund = 0.;
            wallet.insert();
            this.triggers.creationSuccess.dispatch();
        }
    }

    public function getAdminError() {
        return this.admin_error;
    }

    // The main view of the widget
    public function display(): Void {}

    // Admin
    public function admin(): Void {}

    // Create a new currency using the name and the rate
    public function createCurrency(args: { name: String, rate: String }): Void {
        var cur_list = Currency.manager.search({ name: args.name });
        // if arguments exists and are valids
        if (args.rate == "" || args.name == "" || Std.parseFloat(args.rate) == Math.NaN) {
            this.admin_error = FieldEmpty;
            this.triggers.currencyCreationFail.dispatch({error: FieldEmpty});
        } else if (!cur_list.isEmpty()) { // if the list is not empty, currency already exist
            this.admin_error = CurrencyAlreadyExist;
            this.triggers.currencyCreationFail.dispatch({error: CurrencyAlreadyExist});
        } else { // create the currency, all the params are valid
            var cur = new Currency();
            cur.name = args.name;
            cur.rate = Std.parseFloat(args.rate);
            cur.insert();
            this.triggers.currencyCreationSuccess.dispatch();
        }
    }

    // Remove a currency using it id
    public function removeCurrency(args: { id: Int }): Void {
        // Only a logged user can remove a currency
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.user_authenticated = false;
            this.triggers.currencyRemoveFail.dispatch({error: UserNotAuthenticate});
        } else {
            try { // try to retrieve the currency, then delete it...
                var cur = Currency.manager.get(args.id);
                cur.delete();
                this.triggers.currencyRemoveSuccess.dispatch();
            } catch( unknown : Dynamic ) { // ... or display an error message.
                this.admin_error = CurrencyDontExist;
                this.triggers.currencyRemoveFail.dispatch({error: CurrencyDontExist});
            }
        }
    }

    public function setSiteCurrency(args: {id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.user_authenticated = false;
            this.triggers.setSiteCurrencyFail.dispatch();
        } else {
            var cur;
            try { // try to retrieve the SiteCurrency, then use it
                cur = SiteCurrency.manager.get(WalletImpl.WEBSITE_ID);
            } catch( unknown : Dynamic ) { // ... or create a new
                cur = new SiteCurrency();
                cur.insert();
            }
            if (this.setCurrencyAsSiteCurrency(cur, args.id)) {
                this.triggers.setSiteCurrencySuccess.dispatch();
            } else {
                this.triggers.setSiteCurrencyFail.dispatch();
            }
        }
    }

    private function setCurrencyAsSiteCurrency(site_currency: SiteCurrency, id: Int): Bool {
        var return_value = false;

        try { // try to retrieve the currency, then delete use it...
            var currency = Currency.manager.get(id);
            site_currency.currency_id = currency.id;
            site_currency.update();
            return_value = true;
        } catch( unknown : Dynamic ) { // ... or display an error message.
            return_value = false;
        }
        return return_value;
    }

    // tools

    public function getCurrentRealFunds(user: User): Option<Float> {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): Some(wallet.fund);
            case None: None;
        };
    }

    public function getCurrentFunds(user: User, currency: Currency): Option<Float> {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): Some(currency.convertToCurrency(wallet.fund));
            case None: None;
        };
    }

    public function addRealFunds(user: User, value: Float): Bool {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): {
                wallet.fund += value;
                wallet.update();
                true;
            };
            case None: false;
        };
    }

    public function addFunds(user: User, currency: Currency, value: Float): Bool {
        return this.addRealFunds(user, currency.convertToReal(value));
    }

    public function consumeRealFunds(user: User, quantity: Float): Bool {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): {
                wallet.fund -= quantity;
                if (wallet.fund >= 0.) {
                    wallet.update();
                    true;
                } else {
                    false;
                }
                true;
            };
            case None: false;
        };
    }

    public function consumeFunds(user: User, currency: Currency, quantity: Float): Bool {
        return this.consumeRealFunds(user, currency.convertToReal(quantity));
    }

    // Get the complete list of all currencys
    public function getCurrencys(): List<Dynamic> {
        var currencys: List<Dynamic> = new List<Dynamic>();

        for (c in Currency.manager.dynamicSearch( {} )) {
            currencys.push({
                currency_name: c.name,
                currency_rate: c.rate,
                currency_id: c.id
            });
        }
        return currencys;
    }

    public function getSiteCurrency(): Option<Currency> {
        var currency: Option<Currency> = None;

        try { // try to retrieve the SiteCurrency, then the currency
            var site_currency = SiteCurrency.manager.get(WalletImpl.WEBSITE_ID);
            currency = Some(Currency.manager.get(site_currency.currency_id));
        } catch( unknown : Dynamic ) { // ... or return null

            currency = None;
        }

        return currency;
    }

    public function getSiteCurrencyOrDefault(): Currency {
        var currency: Currency;

        try { // try to retrieve the SiteCurrency, then the currency
            var site_currency = SiteCurrency.manager.get(WalletImpl.WEBSITE_ID);
            currency = Currency.manager.get(site_currency.currency_id);
        } catch( unknown : Dynamic ) { // ... or return null
            currency = new Currency();
            currency.rate =  0.;
            currency.name = "";
        }

        return currency;
    }

    public function userHasWallet(user: User): Bool {
        if (user == null) { return false; }
        var wallet = WalletModel.manager.search({ user_id: user.id });

        if (wallet.isEmpty()) { return false; }

        return true;
    }

    public function getUserWallet(user: User): Option<WalletModel> {
        // check if the user is null
        if (user == null) { return None; }
        // get the user wallet
        var wallet = WalletModel.manager.search({ user_id: user.id });
        if (wallet.isEmpty()) { return None; }

        return Some(wallet.first());
    }
}