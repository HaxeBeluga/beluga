// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket.model;

// beluga mods
import beluga.module.account.model.User;


// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_ticket")
@:build(beluga.Database.registerModel())
class TicketModel extends Object {
    public var id: SId;
    public var user_id: SInt;
    public var date: SDateTime;
    public var path_attachment: STinyText;
    public var title: STinyText;
    public var content: STinyText;
    public var status: SInt;
    @:relation(user_id)
    public var user: User;
}