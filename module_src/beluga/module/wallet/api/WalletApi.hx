// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.Beluga;
import beluga.BelugaException;

// Beluga mods
import beluga.module.wallet.Wallet;

class WalletApi {
    public var beluga : Beluga;
    public var module : Wallet;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doCreate(): Void {
        module.create();
    }

    public function doDisplay(): Void {
        module.display();
    }

    public function doAdmin(): Void {
        module.admin();
    }

    public function doCreateCurrency(args: { name: String, rate: String }): Void {
        module.createCurrency(args);
    }

    public function doRemoveCurrency(args: { id: Int }): Void {
        module.removeCurrency(args);
    }

    public function doSetSiteCurrency(args: {id: Int }): Void {
        module.setSiteCurrency(args);
    }

    public function doDefault(): Void {
        trace("Wallet default page");
    }
}