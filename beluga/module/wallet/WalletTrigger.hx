// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.wallet;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import beluga.module.wallet.WalletErrorKind;

import sys.db.Types;

class WalletTrigger {
    public var creationSuccess = new TriggerVoid();
    public var creationFail = new TriggerVoid();
    public var currencyCreationSuccess = new TriggerVoid();
    public var currencyCreationFail = new Trigger<{error: WalletErrorKind}>();
    public var currencyRemoveSuccess = new TriggerVoid();
    public var currencyRemoveFail = new Trigger<{error: WalletErrorKind}>();
    public var setSiteCurrencySuccess = new TriggerVoid();
    public var setSiteCurrencyFail = new TriggerVoid();

    public function new() {}
}