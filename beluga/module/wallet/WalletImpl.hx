package beluga.module.wallet;

// Haxe
import haxe.xml.Fast;
import haxe.ds.Option;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.wallet.model.Currency;
import beluga.module.wallet.model.SiteCurrency;
import beluga.module.wallet.model.WalletModel;
import beluga.module.account.model.User;
import beluga.module.account.Account;

class WalletImpl extends ModuleImpl implements WalletInternal {
    public var triggers = new WalletTrigger();
    public var widgets: WalletWidget;
    // two errors for admin: global -> cannot access, local -> fields errors.
    var admin_global_error = "";
    var admin_local_error = "";
    // two error for user widget
    var global_error = "";
    var local_error = "";

    // ID of the unique field of SiteCurrency
    public static var WEBSITE_ID = 1;

    public function new() { super(); }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new WalletWidget();
    }

    // pages

    public function create(): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.global_error = "Vous devez etres identifie pour acceder au widget porte-feuille !";
            this.triggers.creationFail.dispatch();
        } else { // get the logged user
            var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
            var wallet = new WalletModel();
            wallet.wa_user_id = user.id;
            wallet.wa_fund = 0.;
            wallet.insert();
            this.triggers.creationSuccess.dispatch();
        }
    }

    // The main view of the widget
    public function display(): Void {}

    public function getShowContext(): Dynamic {
        var user: User = null;
        var has_wallet = 1;
        var currency_name = "";
        var user_founds = 0.;

        // check if the user is logged
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.global_error = "Vous devez etres identifie pour acceder au widget porte-feuille !";
        } else { // get the logged user
            user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        }

        // retrieve wallet informations if the user has a wallet
        switch (this.getUserWallet(user)) {
            case Some(wallet): {
                var site_currency = this.getSiteCurrencyOrDefault();
                has_wallet = 0;
                user_founds = site_currency.convertToCurrency(wallet.wa_fund);
                currency_name = site_currency.cu_name;
            };
            case None: {};
        }

        return {
            wallet_local_error: this.local_error,
            wallet_global_error: this.global_error,
            has_wallet: has_wallet,
            user: user,
            founds: user_founds,
            currency_name: currency_name
        };
    }

    // Admin
    public function admin(): Void {}

    // Return the context to display the admin widget
    public function getAdminContext(): Dynamic {
        // Check if user is logged to display the widget, if not set the global error
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.admin_global_error = "Vous devez etres identifie pour acceder a ce widget !";
        }
        // retrieve the currencys list
        var currency_list = this.getCurrencys();
        // then the site currency
        var site_currency = this.getSiteCurrencyOrDefault();
        return {
            admin_wallet_global_error: this.admin_global_error,
            admin_wallet_local_error: this.admin_local_error,
            currency_list: currency_list,
            site_currency: site_currency
        };
    }

    // Create a new currency using the name and the rate
    public function createCurrency(args: { name: String, rate: String }): Void {
        var cur_list = Currency.manager.search({ cu_name: args.name });
        // if arguments exists and are valids
        if (args.rate == "" || args.name == "" || Std.parseFloat(args.rate) == Math.NaN) {
            this.admin_local_error = "Vous devez remplir les deux champs !";
            this.triggers.currencyCreationFail.dispatch();
        } else if (!cur_list.isEmpty()) { // if the list is not empty, currency already exist
            this.admin_local_error = "Cet monnaie existe deja !";
            this.triggers.currencyCreationFail.dispatch();
        } else { // create the currency, all the params are valid
            var cur = new Currency();
            cur.cu_name = args.name;
            cur.cu_rate = Std.parseFloat(args.rate);
            cur.insert();
            this.triggers.currencyCreationSuccess.dispatch();
        }
    }

    // Remove a currency using it id
    public function removeCurrency(args: { id: Int }): Void {
        // Only a logged user can remove a currency
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.admin_local_error = "Vous devez etre connecte pour realiser cette action !";
            this.triggers.currencyRemoveFail.dispatch();
        } else {
            try { // try to retrieve the currency, then delete it...
                var cur = Currency.manager.get(args.id);
                cur.delete();
                this.triggers.currencyRemoveSuccess.dispatch();
            } catch( unknown : Dynamic ) { // ... or display an error message.
                this.admin_local_error = "Cette monnaie n'existe pas";
                this.triggers.currencyRemoveFail.dispatch();
            }
        }
    }

    public function setSiteCurrency(args: {id: Int }): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.admin_local_error = "Vous devez etre connecte pour realiser cette action !";
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
            site_currency.si_cu_id = currency.cu_id;
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
            case Some(wallet): Some(wallet.wa_fund);
            case None: None;
        };
    }

    public function getCurrentFunds(user: User, currency: Currency): Option<Float> {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): Some(currency.convertToCurrency(wallet.wa_fund));
            case None: None;
        };
    }

    public function addRealFunds(user: User, value: Float): Bool {
        return switch (this.getUserWallet(user)) {
            case Some(wallet): {
                wallet.wa_fund += value;
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
                wallet.wa_fund -= quantity;
                if (wallet.wa_fund >= 0.) {
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
                currency_name: c.cu_name,
                currency_rate: c.cu_rate,
                currency_id: c.cu_id
            });
        }
        return currencys;
    }

    public function getSiteCurrencyOrDefault(): Currency {
        var currency = null;

        try { // try to retrieve the SiteCurrency, then the currency
            var site_currency = SiteCurrency.manager.get(WalletImpl.WEBSITE_ID);
            currency = Currency.manager.get(site_currency.si_cu_id);
        } catch( unknown : Dynamic ) { // ... or return null
            currency = new Currency();
            currency.cu_rate =  0.;
            currency.cu_name = "No currency set for this site !";
        }

        return currency;
    }

    public function userHasWallet(user: User): Bool {
        if (user == null) { return false; }
        var wallet = WalletModel.manager.search({ wa_user_id: user.id });

        if (wallet.isEmpty()) { return false; }

        return true;
    }

    public function getUserWallet(user: User): Option<WalletModel> {
        // check if the user is null
        if (user == null) { return None; }
        // get the user wallet
        var wallet = WalletModel.manager.search({ wa_user_id: user.id });
        if (wallet.isEmpty()) { return None; }

        return Some(wallet.first());
    }
}