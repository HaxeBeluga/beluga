// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.model;

import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_currency")
class Currency extends Object {
    public var id: SId;
    public var name: SString<32>;
    public var rate: SFloat;

    public function convertToReal(value: Float): Float {
        return value / this.rate;
    }

    public function convertToCurrency(value: Float): Float {
        return value * this.rate;
    }
}