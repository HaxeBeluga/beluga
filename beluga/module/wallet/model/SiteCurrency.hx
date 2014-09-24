// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.model;

// beluga mods
import beluga.module.wallet.model.Currency;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_sitecurrency")
class SiteCurrency extends Object {
    public var id: SId;
    public var currency_id: SInt;
    @:relation(currency_id)
    public var currency: Currency;
}