package beluga.module.market;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;

// Beluga mods
import beluga.module.wallet.Wallet;
import beluga.module.market.model.Product;
import beluga.module.market.model.Cart;
import beluga.module.account.Account;
import beluga.module.account.model.User;

// Haxe
import haxe.xml.Fast;
import haxe.ds.Option;

class MarketImpl extends ModuleImpl implements MarketInternal {
    public var triggers = new MarketTrigger();
    public var widgets: MarketWidget;

    var error = "";
    var info = "";
    var cart_error = "";
    var cart_info = "";

    public function new() { super(); }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new MarketWidget();
    }

    // widget functions

    public function display(): Void {}

    public function getDisplayContext(): Dynamic {
        var product_list = this.getProductList();
        var currency = beluga.getModuleInstance(Wallet).getSiteCurrencyOrDefault().cu_name;
        return {
            market_error: this.error,
            market_info: this.info,
            product_list: product_list,
            currency: currency
        };
    }

    public function admin(): Void {}

    public function getAdminContext(): Dynamic {
        return {};
    }

    public function cart(): Void {}

    public function getCartContext(): Dynamic {
        var user_cart: List<Dynamic> = new List<Dynamic>();
        var currency = beluga.getModuleInstance(Wallet).getSiteCurrencyOrDefault().cu_name;
        var total_price = 0;

        if (!beluga.getModuleInstance(Account).isLogged) {
            this.cart_error = "You must be logged to access your cart";
        } else {
            user_cart = this.getUserCart(beluga.getModuleInstance(Account).loggedUser);
            for( c in user_cart ) {
                total_price += c.product_total_price;
            }
            if (user_cart.length == 0) {
                this.cart_info = "You have no cart and no products at this time !";
            }
        }

        return {
            market_cart_error: this.cart_error,
            market_cart_info: this.cart_info,
            products_list: user_cart,
            currency: currency,
            total_price: total_price
        };
    }

    public function addProductToCart(args: { id: Int }): Void {
        // Check if the user is connected
        if (beluga.getModuleInstance(Account).isLogged) {
            switch (this.getProductFromId(args.id)) {
                case Some(p): { // Le produit existe on l'insert dans le cart
                    var user_id = beluga.getModuleInstance(Account).loggedUser.id;
                    switch (this.getCart(args.id, user_id)) {
                        case Some(cart): {
                            cart.ca_quantity += 1;
                            cart.update();
                            this.info = "One More is added to the cart.";
                        }
                        case None: {
                            var cart = new Cart();
                            cart.ca_user_id = user_id;
                            cart.ca_quantity = 1;
                            cart.ca_product_id = p.pr_id;
                            cart.insert();
                            this.info = "The product is add to the cart.";
                        }
                    };
                    this.triggers.addProductSuccess.dispatch();
                };
                case None: { // le produit n'existe pas on lance une erreur par trigger
                    this.error = "This product doesn't exist or is not available.";
                    this.triggers.addProductFail.dispatch();
                }
            }
        } else { // User is not connected, we throw an error by trigger
            this.error = "You should be connected to add a product to the cart.";
            this.triggers.addProductFail.dispatch();
        }
    }

    public function removeProductInCart(args: { id: Int }): Void {
        if (beluga.getModuleInstance(Account).isLogged) {
            switch (this.getCartById(args.id)) {
                case Some(cart): {
                    cart.delete();
                    this.triggers.removeProductSuccess.dispatch();
                }
                case None: {
                    this.triggers.removeProductFail.dispatch();
                }
            }
        } else { // User is not connected, we throw an error by trigger
            this.error = "You should be connected to remove a product from your cart.";
            this.triggers.removeProductFail.dispatch();
        }
    }

    // Checkout the cart of a given user.
    // this function throw 2 different trigger:
    // on success -> "beluga_market_checkout_cart_success" with in params a list of dynamics wihch
    // contains {user -> the given user, product -> the product bougth, quantity -> the quantity of
    // the given product}
    // on failure -> "beluga_market_checkout_cart_fail"
    public function checkoutCart(): Void {
        if (beluga.getModuleInstance(Account).isLogged) {
            var user = beluga.getModuleInstance(Account).loggedUser;
            var cart = Cart.manager.dynamicSearch( {} );
            var bought_items_list: List<Dynamic> = new List<Dynamic>();
            for (c in cart) {
                bought_items_list.push({
                    user: c.ca_user,
                    product: c.ca_product,
                    quantity: c.ca_quantity
                });
                c.delete();
            }
            beluga.triggerDispatcher.dispatch("beluga_market_checkout_cart_success", [bought_items_list]);
        } else {
            this.error = "You should be connected to remove a product from your cart.";
            this.triggers.checkoutCartFail.dispatch();
        }
    }

    public function getProductList(): List<Dynamic> {
        var product_list: List<Dynamic> = new List<Dynamic>();
        var site_currency = beluga.getModuleInstance(Wallet).getSiteCurrencyOrDefault();

        for (p in Product.manager.dynamicSearch( {} )) {
            product_list.push({
                product_name: p.pr_name,
                product_price: site_currency.convertToCurrency(p.pr_price),
                product_id: p.pr_id,
                product_desc: p.pr_desc,
            });
        }

        return product_list;
    }

    public function getProductFromId(id: Int): Option<Product> {
        var products = Product.manager.search({ pr_id: id });
        return if (products.isEmpty()) { None; } else { Some(products.first()); };
    }

    public function getCartById(id: Int): Option<Cart> {
        // get the cart
        var cart = Cart.manager.search({ ca_id: id });
        if (cart.isEmpty()) { return None; }

        return Some(cart.first());
    }

    // Get a product in the user Cart
    public function getCart(product_id: Int, user_id: Int): Option<Cart> {
        var carts =  Cart.manager.dynamicSearch({ ca_product_id: product_id, ca_user_id: user_id });
        return if (carts.isEmpty()) { None; } else { Some(carts.first()); };
    }

    // Get te complete cart of an User
    public function getUserCart(user: User): List<Dynamic> {
        var cart: List<Dynamic> = new List<Dynamic>();
        var site_currency = beluga.getModuleInstance(Wallet).getSiteCurrencyOrDefault();

        for (c in Cart.manager.dynamicSearch( {ca_user_id: user.id } )) {
            switch (this.getProductFromId(c.ca_product_id)){
                case Some(product): {
                    cart.push({
                        product_name: product.pr_name,
                        product_price: site_currency.convertToCurrency(product.pr_price),
                        product_total_price: site_currency.convertToCurrency(product.pr_price) * c.ca_quantity,
                        product_cart_id: c.ca_id,
                        product_quantity: c.ca_quantity,
                    });
                }
                case None: {}
            }
        }
        return cart;
    }

}