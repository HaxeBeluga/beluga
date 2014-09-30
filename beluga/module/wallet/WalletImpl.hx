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
import beluga.module.wallet.model.WalletModel;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.wallet.WalletErrorKind;
import beluga.module.wallet.repository.WalletRepository;
import beluga.module.wallet.repository.CurrencyRepository;

class WalletImpl extends ModuleImpl implements WalletInternal {
    public var triggers = new WalletTrigger();
    public var widgets: WalletWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/module/wallet/locale/");

    // repository
    public var wallet_repository = new WalletRepository();
    public var currency_repository = new CurrencyRepository();

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
            this.wallet_repository.save(new WalletModel().init(user.id, 0.));
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
            this.currency_repository.save(new Currency().init(args.name, Std.parseFloat(args.rate), false));
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
                this.currency_repository.delete(Currency.manager.get(args.id));
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
            var curr = switch(this.currency_repository.getFromId(args.id)) {
                case Some(c): c;
                case None: {
                    this.triggers.setSiteCurrencyFail.dispatch();
                    return;
                };
            };
            this.currency_repository.setSiteCurrency(curr);
            this.triggers.setSiteCurrencySuccess.dispatch();
        }
    }

    public function getRealFunds(user: User): Option<Float> {
        return switch (this.wallet_repository.getUserWallet(user)) {
            case Some(wallet): Some(wallet.fund);
            case None: None;
        };
    }

    public function getFunds(user: User, currency: Currency): Option<Float> {
        return switch (this.wallet_repository.getUserWallet(user)) {
            case Some(wallet): Some(currency.convertToCurrency(wallet.fund));
            case None: None;
        };
    }

    public function addRealFunds(user: User, value: Float): Bool {
        return switch (this.wallet_repository.getUserWallet(user)) {
            case Some(wallet): {
                wallet.fund += value;
                this.wallet_repository.update(wallet);
                true;
            };
            case None: false;
        };
    }

    public function addFunds(user: User, currency: Currency, value: Float): Bool {
        return this.addRealFunds(user, currency.convertToReal(value));
    }

    public function consumeRealFunds(user: User, quantity: Float): Bool {
        return switch (this.wallet_repository.getUserWallet(user)) {
            case Some(wallet): {
                wallet.fund -= quantity;
                if (wallet.fund >= 0.) {
                    this.wallet_repository.update(wallet);
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

    public function getSiteCurrencyOrDefault(): Currency {
        return this.currency_repository.getSiteCurrencyOrDefault();
    }
}