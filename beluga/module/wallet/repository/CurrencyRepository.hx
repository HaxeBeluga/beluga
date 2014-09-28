// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.repository;

import beluga.core.module.SpodRepository;

// beluga mods
import beluga.module.wallet.model.Currency;

//haxe
import sys.db.Object;
import sys.db.Types;
import haxe.ds.Option;

class CurrencyRepository extends SpodRepository<Currency> {
    public function new() { super(); }

    public function setSiteCurrency(curr: Currency) {
        try {
            var old_curr = Currency.manager.search($site_currency == true).first();
            old_curr.site_currency = false;
            old_curr.update();
        } catch(_: Dynamic) {}
        curr.site_currency = true;
        curr.update();
    }

    // Get the complete list of all currencys
    public function getCurrencys(): List<Currency> {
        // var currencys = new List<Dynamic>();
        // for (c in Currency.manager.dynamicSearch( {} )) {
        //     currencys.push({
        //         name: c.name,
        //         rate: c.rate,
        //         id: c.id
        //     });
        // }
        // return currencys;
        return Currency.manager.dynamicSearch({});
    }

    public function getSiteCurrency(): Option<Currency> {
        var curr: Currency = Currency.manager.search($site_currency == true).first();
        if (curr == null) {
            return None;
        }
        return Some(curr);
    }

    public function getSiteCurrencyOrDefault(): Currency {
        return switch (this.getSiteCurrency()) {
            case Some(c): c;
            case None: Currency.newInit("", 0., false);
        };
    }

    public function getFromId(id: Int): Option<Currency> {
        var curr = Currency.manager.get(id);
        if (curr != null) {
            return Some(curr);
        } else {
            return None;
        }
    }
}