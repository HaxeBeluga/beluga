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

//haxe
import sys.db.Object;
import sys.db.Types;

class WalletRepository extends SpodRepository<WalletModel> {
    public function new() { super(); }
}