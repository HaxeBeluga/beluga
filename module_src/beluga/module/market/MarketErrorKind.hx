// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market;

import beluga.module.market.model.Product;

enum MarketErrorKind {
    MarketOneMoreProductToCart(product: Product);
    MarketNewProductToCart(product: Product);
    MarketUserNotLogged;
    MarketUnknownProduct(id: Int);
    MarketProductAlreadyExist(product: Product);
    MarketNewProductAdded(product: Product);
    MarketProductDeleted(product: Product);
    MarketProductToShow(product: Product);
    MarketNone;
}