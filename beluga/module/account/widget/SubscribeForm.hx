// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.account.AccountImpl;

class SubscribeForm extends MttWidget<AccountImpl> {

    public function new (mttfile = "beluga_account_subscribe.mtt") {
        super(AccountImpl, mttfile);
    }

    override private function getContext(): Dynamic {
        return {};
    }

}