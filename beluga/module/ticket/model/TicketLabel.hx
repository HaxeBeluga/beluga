// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket.model;

// beluga mods
import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.TicketLabel;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_tic_ticketlabel")
@:build(beluga.core.Database.registerModel())
class TicketLabel extends Object {
    public var id: SId;
    public var label_id: SInt;
    public var ticket_id: SInt;
    @:relation(label_id)
    public var label: Label;
    @:relation(ticket_id)
    public var ticket: TicketModel;
}