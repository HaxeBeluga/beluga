// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.market.Market;
import beluga.core.BelugaI18n;
import beluga.module.wallet.Wallet;
import beluga.module.market.MarketErrorKind;
import beluga.module.wallet.repository.CurrencyRepository;

class Display extends MttWidget<MarketImpl> {

    public function new (mttfile = "beluga_market_display.mtt") {
        super(Market, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/market/view/locale/display/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var currency_repository = new CurrencyRepository();
        var product_list = mod.getProductList();
        var currency = switch(currency_repository.getSiteCurrency()) {
            case Some(c): c.name;
            case None: BelugaI18n.getKey(this.i18n, "missing_currency");
        };

        return {
            market_error: this.getErrorString(mod.error),
            market_info: this.getErrorString(mod.info),
            products: product_list,
            currency: currency
        };
    }

    private function getErrorString(error: MarketErrorKind) {
        return switch(error) {
            case MarketOneMoreProductToCart(_): BelugaI18n.getKey(this.i18n, "one_more_product");
            case MarketNewProductToCart(_): BelugaI18n.getKey(this.i18n, "product_add_to_cart");
            case MarketUserNotLogged: BelugaI18n.getKey(this.i18n, "user_not_logged");
            case MarketUnknownProduct(_): BelugaI18n.getKey(this.i18n, "unknown_product");
            case MarketNone: "";
        };
    }
}