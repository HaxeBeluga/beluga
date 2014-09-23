// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_acc_user")
@:id(id)
@:index(login, unique)
class User extends Object {
    public var id : SId;
    public var login : SString<32>;
    public var hashPassword : SString<32>;
    public var subscribeDateTime : SDateTime;
    public var emailVerified : SBool;
    public var isAdmin : SBool;
    public var isBan: SBool;
    public var sponsor_id: SInt;
    public var email : SString<128>;

    @:relation(sponsor_id) public var sponsor : User;

    public function setPassword(password : String) {
        hashPassword = haxe.crypto.Md5.encode(password);
    }

}