// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;
import beluga.module.account.model.User;
import beluga.module.account.Account.LoginFailCause;

class AccountTrigger {
    //Login
    public var loginFail = new Trigger<{err : LoginFailCause}>();
    public var loginSuccess = new TriggerVoid();

    //Logout
    public var afterLogout = new TriggerVoid();

    //subscribe
    public var subscribeFail = new Trigger<{err : String}>();
    public var subscribeSuccess = new Trigger<{user : User}>();

    //delete
    public var deleteFail = new Trigger<{err : String}>();
    public var deleteSuccess = new TriggerVoid();

    //edit
    public var editFail = new Trigger<{err : String}>();
    public var editSuccess = new TriggerVoid();

    //ban
    public var banFail = new Trigger<{err : String}>();
    public var banSuccess = new TriggerVoid();

    //unban
    public var unbanFail = new Trigger<{err : String}>();
    public var unbanSuccess = new TriggerVoid();

    //friend
    public var friendFail = new Trigger<{err : String}>();
    public var friendSuccess = new TriggerVoid();

    //unfriend
    public var unfriendFail = new Trigger<{err : String}>();
    public var unfriendSuccess = new TriggerVoid();

    //blacklist
    public var blacklistFail = new Trigger<{err : String}>();
    public var blacklistSuccess = new TriggerVoid();

    //unblacklist
    public var unblacklistFail = new Trigger<{err : String}>();
    public var unblacklistSuccess = new TriggerVoid();

    public var showUser = new Trigger<{ id: Int}>();
    public var defaultPage = new TriggerVoid();

    public function new()
    {

    }

}