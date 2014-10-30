// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.notification.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_notif_notification")
@:id(id)
@:build(beluga.core.Database.registerModel())
class NotificationModel extends Object {
    public var id : SId;
    public var title : STinyText;
    public var text : STinyText;
    public var user_id : SInt;
    public var hasBeenRead : SBool;
    public var creationDate : SDateTime;
    @:relation(user_id) public var user : User;
}