// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.model;

// beluga mods
import beluga.module.account.model.User;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_wal_wallet")
class WalletModel extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var fund: SFloat;
    @:relation(user_id)
    public var user: User;

    public function new() { super(); }

    public function init(user_id: Int, fund: Float) {
        this.user_id = user_id;
        this.fund = fund;

        return this;
    }
}