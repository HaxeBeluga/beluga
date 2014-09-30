// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.repository;

// beluga core
import beluga.core.module.SpodRepository;

// beluga mods
import beluga.module.wallet.model.WalletModel;
import beluga.module.account.model.User;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

class WalletRepository extends SpodRepository<WalletModel> {
    public function new() { super(); }

    public function getUserWallet(user: User): Option<WalletModel> {
        if (user == null) { return None; }
        // get the user wallet
        var wallet = WalletModel.manager.search({ user_id: user.id });
        if (wallet.isEmpty()) { return None; }

        return Some(wallet.first());
    }

     public function userHasWallet(user: User): Bool {
        if (user == null) { return false; }
        var wallet = WalletModel.manager.search({ user_id: user.id });

        if (wallet.isEmpty()) { return false; }

        return true;
    }
}