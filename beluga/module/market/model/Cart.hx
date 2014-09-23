// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.model;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.market.model.Product;

// Spod
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_mar_cart")
class Cart extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var product_id: SInt;
    public var quantity: SInt;
    @:relation(user_id)
    public var user: User;
    @:relation(product_id)
    public var product: Product;
}