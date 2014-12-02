// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account;
import beluga.module.config.widget.ConfigWidget;
import beluga.module.account.widget.LoginForm;
import beluga.module.account.widget.SubscribeForm;


class AccountWidget
{
    public var loginForm = new LoginForm();

    public var subscribeForm  = new SubscribeForm();

    public var configWidget = new ConfigWidget(AccountConfig.get, "/beluga/account/saveConfig");

    public function new()
    {

    }

}