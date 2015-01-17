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
import beluga.widget.Layout;
import beluga.I18n;
import beluga.module.fileupload.Fileupload;
import beluga.module.market.model.Product;
import beluga.module.account.Account;

class Update extends MttWidget<Market> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/market/view/tpl/update.mtt");
        super(Market, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/market/view/locale/update/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var beluga = Beluga.getInstance();
        var images = new List<Dynamic>();
        var error = "";
        var success = "";
        var product: Product = new Product();
        var image_name: String = "";

        if (!beluga.getModuleInstance(Account).isLogged) {
            error = BelugaI18n.getKey(this.i18n, "user_not_logged");
        } else {
            images = beluga.getModuleInstance(Fileupload).getUserFileList(beluga.getModuleInstance(Account).loggedUser.id);
        }

        switch (this.mod.info) {
            case MarketProductToShow(p): {
                product = p;
                if (p.image != null) {
                    image_name = p.image.name;
                } else {
                    image_name = "None";
                }
            };
            case _: product = null;
        };

        return {
            error: this.getErrorString(this.mod.error),
            success: "",
            product: product,
            image_name: image_name,
            image_list: images,
            module_name: "Market update"
        };
    }

    private function getErrorString(error: MarketErrorKind) {
        return switch(error) {
            case MarketOneMoreProductToCart(_): BelugaI18n.getKey(this.i18n, "one_more_product");
            case MarketNewProductToCart(_): BelugaI18n.getKey(this.i18n, "product_add_to_cart");
            case MarketUserNotLogged: BelugaI18n.getKey(this.i18n, "user_not_logged");
            case MarketUnknownProduct(_): BelugaI18n.getKey(this.i18n, "unknown_product");
            case MarketProductAlreadyExist(_): BelugaI18n.getKey(this.i18n, "product_already_exist");
            case MarketNewProductAdded(_): BelugaI18n.getKey(this.i18n, "new_prod");
            case MarketProductDeleted(_): BelugaI18n.getKey(this.i18n, "product_deleted");
            case MarketProductToShow(_): BelugaI18n.getKey(this.i18n, "product_deleted");
            case MarketNone: "";
        };
    }
}