// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.market.Market;
import beluga.module.wallet.Wallet;
import beluga.I18n;
import beluga.module.account.Account;
import beluga.module.wallet.repository.CurrencyRepository;
import beluga.widget.Layout;

class Cart extends MttWidget<Market> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/market/view/tpl/cart.mtt");
        super(Market, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/market/view/locale/cart/", mod.i18n);
    }

    override private function getContext(): Dynamic{
        var currency_repository = new CurrencyRepository();
        var beluga = Beluga.getInstance();
        var user_cart = new List<Dynamic>();
        var cart_error = "";
        var cart_info = "";
        var currency = switch(currency_repository.getSiteCurrency()) {
            case Some(c): c.name;
            case None: BelugaI18n.getKey(this.i18n, "missing_currency");
        };

        var total_cart_price = 0;

        if (!beluga.getModuleInstance(Account).isLogged) {
            cart_error = BelugaI18n.getKey(this.i18n, "user_not_logged");
        } else {
            user_cart = mod.getUserCart(beluga.getModuleInstance(Account).loggedUser);
            user_cart.map(function(p) {total_cart_price += p.product_total_price;});

            if (user_cart.length == 0) {
                cart_info = BelugaI18n.getKey(this.i18n, "no_product");
            }
        }

        return {
            error: if (cart_error == "") { this.getErrorString(mod.error); } else { cart_error; },
            success: cart_info,
            products_list: user_cart,
            currency: currency,
            total_price: total_cart_price,
            module_name: "User Cart"
        };
    }

    private function getErrorString(error: MarketErrorKind) {
        return switch(error) {
            case MarketOneMoreProductToCart(_): BelugaI18n.getKey(this.i18n, "one_more_product");
            case MarketNewProductToCart(_): BelugaI18n.getKey(this.i18n, "product_add_to_cart");
            case MarketUserNotLogged: BelugaI18n.getKey(this.i18n, "user_not_logged");
            case MarketUnknownProduct(_): BelugaI18n.getKey(this.i18n, "unknown_product");
            case MarketNone: null;
        };
    }
}