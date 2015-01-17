// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.repository;

// beluga core
import beluga.module.SpodRepository;

// beluga mods
import beluga.module.market.model.Product;
import beluga.module.account.model.User;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

class ProductRepository extends SpodRepository<Product> {

    public function new() { super(); }

    public function getProductFromName(name: String): Option<Product> {
        var product = Product.manager.search({name: name});
        if (product.isEmpty()) { return None;}
        return Some(product.first());
    }

    public function getProductFromId(id: Int): Option<Product> {
        var product = Product.manager.search({id: id});
        if (product.isEmpty()) { return None;}
        return Some(product.first());
    }

}