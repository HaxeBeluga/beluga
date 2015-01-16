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
import beluga.I18n;
import beluga.module.wallet.Wallet;
import beluga.module.market.MarketErrorKind;
import beluga.module.wallet.repository.CurrencyRepository;
import beluga.widget.Layout;

class Display extends MttWidget<Market> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/market/view/tpl/display.mtt");
        super(Market, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/market/view/locale/display/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var currency_repository = new CurrencyRepository();
        var product_list = mod.getProductList();
        var currency = switch(currency_repository.getSiteCurrency()) {
            case Some(c): c.name;
            case None: BelugaI18n.getKey(this.i18n, "missing_currency");
        };

        return {
            error: this.getErrorString(mod.error),
            success: this.getErrorString(mod.info),
            products: product_list,
            currency: currency,
            module_name: "Market"
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