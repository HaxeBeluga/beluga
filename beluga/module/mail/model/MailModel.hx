// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.mail.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_mail_mail")
@:id(id)
@:build(beluga.core.Database.registerModel())
class MailModel extends Object {
    public var id : SId;
    public var subject : STinyText;
    public var text : SText;
    public var user_id : SInt;
    public var receiver : STinyText;
    public var sentDate : SDateTime;
    public var hasBeenSent : SBool;
    @:relation(user_id) public var user : User;
}