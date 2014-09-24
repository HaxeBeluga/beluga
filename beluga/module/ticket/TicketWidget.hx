// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket;
import beluga.module.ticket.widget.Browse;
import beluga.module.ticket.widget.Create;
import beluga.module.ticket.widget.Show;
import beluga.module.ticket.widget.Admin;

class TicketWidget {
    public var browse = new Browse();
    public var create = new Create();
    public var show = new Show();
    public var admin = new Admin();

    public function new() {}
}