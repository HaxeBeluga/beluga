// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

// Beluga core
import beluga.module.Module;
import beluga.Beluga;
import beluga.I18n;
import beluga.module.market.api.MarketApi;

// Beluga mods
import beluga.module.wallet.Wallet;
import beluga.module.market.model.Product;
import beluga.module.market.model.Cart;
import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.module.market.MarketErrorKind;

// Haxe
import haxe.xml.Fast;
import haxe.ds.Option;

@:Css("/beluga/module/market/view/css/")
class Market extends Module {
    public var triggers = new MarketTrigger();
    public var widgets: MarketWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/market/locale/");

    public var error: MarketErrorKind = MarketNone;
    public var info: MarketErrorKind = MarketNone;

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new MarketWidget();
        beluga.api.register("market", new MarketApi(beluga, this));
    }

    // widget functions

    public function display(): Void {}

    public function admin(): Void {}

    public function cart(): Void {}

    public function addProductToCart(args: { id: Int }): Void {
        // Check if the user is connected
        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            switch (this.getProductFromId(args.id)) {
                case Some(p): { // Le produit existe on l'insert dans le cart
                    var user_id = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
                    switch (this.isProductInCart(p, user_id)) {
                        case Some(cart): {
                            cart.quantity += 1;
                            cart.update();
                            this.info = MarketOneMoreProductToCart(p);
                        }
                        case None: {
                            var cart = new Cart();
                            cart.user_id = user_id;
                            cart.quantity = 1;
                            cart.product_id = p.id;
                            cart.insert();
                            this.info = MarketNewProductToCart(p);
                        }
                    };
                    this.triggers.addProductSuccess.dispatch({product: p});
                };
                case None: { // le produit n'existe pas on lance une erreur par trigger
                    this.error = MarketUnknownProduct(args.id);
                    this.triggers.addProductFail.dispatch({error: this.error});
                }
            }
        } else { // User is not connected, we throw an error by trigger
            this.error = MarketUserNotLogged;
            this.triggers.addProductFail.dispatch({error: this.error});
        }
    }

    public function removeProductInCart(args: { id: Int }): Void {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            switch (this.getCartById(args.id)) {
                case Some(cart): {
                    cart.delete();
                    this.triggers.removeProductSuccess.dispatch();
                }
                case None: {
                    this.error = MarketUnknownProduct(args.id);
                    this.triggers.removeProductFail.dispatch({error: this.error});
                }
            }
        } else { // User is not connected, we throw an error by trigger
            this.error = MarketUserNotLogged;
            this.triggers.removeProductFail.dispatch({error: this.error});
        }
    }

    // Checkout the cart of a given user.
    // this function throw 2 different trigger:
    // on success -> "beluga_market_checkout_cart_success" with in params a list of dynamics wihch
    // contains {user -> the given user, product -> the product bougth, quantity -> the quantity of
    // the given product}
    // on failure -> "beluga_market_checkout_cart_fail"
    public function checkoutCart(): Void {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
            var cart = Cart.manager.dynamicSearch( {} );
            var bought_items_list: List<Dynamic> = new List<Dynamic>();
            for (c in cart) {
                bought_items_list.push({
                    user: c.user,
                    product: c.product,
                    quantity: c.quantity
                });
                c.delete();
            }
            this.triggers.checkoutCartSuccess.dispatch();
            // beluga.triggerDispatcher.dispatch("beluga_market_checkout_cart_success", [bought_items_list]);
        } else {
            this.error = MarketUserNotLogged;
            this.triggers.checkoutCartFail.dispatch({error: MarketUserNotLogged});
        }
    }

    public function getProductList(): List<Product> {
        var site_currency = Beluga.getInstance().getModuleInstance(Wallet).getSiteCurrencyOrDefault();
        var products = Product.manager.dynamicSearch({}).map(function(p) {
            var product = new Product();
            product.name = p.name;
            product.price = site_currency.convertToCurrency(p.price);
            product.id = p.id;
            product.desc = p.desc;
            product.stock = p.stock;
            return product;
        });

        return products;
    }

    public function getProductFromId(id: Int): Option<Product> {
        var products = Product.manager.search({ id: id });
        return if (products.isEmpty()) { None; } else { Some(products.first()); };
    }

    public function getCartById(id: Int): Option<Cart> {
        // get the cart
        var cart = Cart.manager.search({ id: id });
        if (cart.isEmpty()) { return None; }

        return Some(cart.first());
    }

    // Get a product in the user Cart
    public function isProductInCart(product: Product, user_id: Int): Option<Cart> {
        var carts =  Cart.manager.dynamicSearch({ product_id: product.id, user_id: user_id });
        return if (carts.isEmpty()) { None; } else { Some(carts.first()); };
    }

    // Get te complete cart of an User
    public function getUserCart(user: User): List<Dynamic> {
        var cart = new List<Dynamic>();
        var site_currency = Beluga.getInstance().getModuleInstance(Wallet).getSiteCurrencyOrDefault();

        for (c in Cart.manager.dynamicSearch( { user_id: user.id } )) {
            switch (this.getProductFromId(c.product_id)){
                case Some(product): {
                    cart.push({
                        product_name: product.name,
                        product_price: site_currency.convertToCurrency(product.price),
                        product_total_price: site_currency.convertToCurrency(product.price) * c.quantity,
                        product_cart_id: c.id,
                        product_quantity: c.quantity,
                    });
                }
                case None: {}
            }
        }
        return cart;
    }

}