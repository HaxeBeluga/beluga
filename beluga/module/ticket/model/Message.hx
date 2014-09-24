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
import beluga.module.ticket.model.TicketModel;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_message")
class Message extends Object {
    public var id: SId;
    public var content: STinyText;
    public var author_id: SInt;
    public var creation_date: SDateTime;
    public var path_attachment: STinyText;
    public var ticket_id: SInt;
    @:relation(author_id)
    public var author: User;
    @:relation(ticket_id)
    public var ticket: TicketModel;
}