// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.ticket;

// Haxe
import beluga.module.ticket.api.TicketApi;
import haxe.xml.Fast;

// Beluga core
import beluga.module.Module;
import beluga.Beluga;
import beluga.I18n;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.Label;
import beluga.module.ticket.model.Message;
import beluga.module.ticket.model.TicketLabel;
import beluga.module.ticket.model.Assignement;
import beluga.module.account.Account;
import beluga.module.ticket.TicketErrorKind;

import sys.db.Manager;

@:Css("/beluga/module/ticket/view/css/")
class Ticket extends Module {
    public var triggers = new TicketTrigger();
    public var widgets: TicketWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/ticket/locale/");

    public var show_id: Int = 0;
    public var error: TicketErrorKind = TicketErrorNone;

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new TicketWidget();
        beluga.api.register("ticket", new TicketApi(beluga, this));
    }

    /** Actions trigger **/

    public function browse(): Void{
        this.triggers.browse.dispatch();
    }

    public function getTickets(): {closed: Int, open: Int, list: List<Dynamic>} {
        var tickets = new List<Dynamic>();
        var message_count: Int = 0;
        var open: Int = 0;
        var closed: Int = 0;
        var status: String = "open";

        // Store all tickets in a Dynamic
        var row = Manager.cnx.request("SELECT * from beluga_tic_ticket ORDER BY date DESC");
        for (t in row) {
            // retrieve ticket status
            if (t.status == 1) { status = "open"; }
            else { status = "closed"; }

            // retrieve message count for this ticket
            message_count = this.getTicketMessageCount(t.ti_id);

            // insert tickets data
            tickets.push({
                ticket_owner: User.manager.get(t.user_id).login,
                ticket_owner_id: User.manager.get(t.user_id).id,
                ticket_subject: t.title,
                ticket_date: t.date,
                ticket_id: t.id,
                ticket_status: status,
                ticket_comments_count: message_count
            });

            // count closed / open tickets
            if (t.status == 1) { open += 1; }
            else { closed += 1; }

            message_count = 0;
        }

        return {
            closed: closed,
            open: open,
            list: tickets
        };

    }

    public function create(): Void {
        this.triggers.create.dispatch();
    }

    public function show(args: { id: Int }): Void {
        this.show_id = args.id;
        this.triggers.show.dispatch();
    }

    /// Just get the id of the ticket, then reopen it
    /// FIXME: Check if the user is logged then reopen else error message
    public function reopen(args: { id: Int }): Void {
        this.show_id = args.id;

         // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
        } else {
            var ticket = TicketModel.manager.get(args.id);
            ticket.status = 1;
            ticket.update();
        }
        this.show(args);
    }

    /// Just get the id of the ticket, then close it
    /// FIXME: Check if the user is logged then closes else error message
    public function close(args: { id: Int }): Void {
        this.show_id = args.id;

        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
        } else {
            var ticket = TicketModel.manager.get(args.id);
            ticket.status = 0;
            ticket.update();
        }
        this.show(args);
    }

    public function comment(args: {
        id: Int,
        message: String
    }): Void  {
        this.show_id = args.id;

        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
            this.triggers.commentFail.dispatch({error: TicketUserNotLogged});
        } else if (args.message.length == 0) {
            this.error = TicketMessageEmpty;
            this.triggers.commentFail.dispatch({error: TicketMessageEmpty});
        } else {
            var message: Message = new Message();
            message.content = args.message;
            message.author_id = account.loggedUser.id;
            message.creation_date = Date.now();
            message.ticket_id = args.id;
            message.insert();
            this.triggers.commentSuccess.dispatch({id: args.id});
            this.notifyTicketComment(args.id);
        }
    }

    public function notifyTicketComment(ticket_id: Int) {
        var ticket = TicketModel.manager.search($id == ticket_id).first();
        var notify = {
            title: "New comment !",
            text: "Someone posted a new comment to your ticket: " + ticket.title +
            " <a href=\"/beluga/ticket/show?id=" + ticket_id + "\">See</a>" +  ".",
            user_id: ticket.user_id
        };
        this.triggers.assignNotify.dispatch(notify);
    }

    public function submit(args: {
        title: String,
        message: String,
        assignee: String
    }): Void {
        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        var ticket = new TicketModel();
        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
            this.triggers.submitFail.dispatch({error: TicketUserNotLogged});
        } else if (args.title.length == 0) {
            this.error = TicketTitleEmpty;
            this.triggers.submitFail.dispatch({error: TicketTitleEmpty});
        } else {
            ticket.user_id = account.loggedUser.id;
            ticket.date = Date.now();
            ticket.title = args.title;
            ticket.content = args.message;
            ticket.status = 1;
            ticket.insert();
            var ticket_id: Int = ticket.id;
            this.show_id = ticket_id;
            if (User.manager.search($login == args.assignee).first() != null) {
                var assignement = new Assignement();
                assignement.user_id =  User.manager.search($login == args.assignee).first().id;
                assignement.ticket_id = ticket.id;
                assignement.insert();
                var args = {
                    title: "Ticket assignnment: " + args.title + " !",
                    text: "You've been assigned to the ticket number " + ticket_id + ", " +
                    args.title + " by " + account.loggedUser.login +
                    " <a href=\"/beluga/ticket/show?id=" + ticket_id + "\">See</a>" + ".",
                    user_id: assignement.user_id
                };
                this.triggers.assignNotify.dispatch(args);
            }
            this.show_id = ticket_id;
            this.triggers.submitSuccess.dispatch({id: ticket_id});
        }
    }

    public function admin(): Void {
        this.triggers.admin.dispatch();
    }

    public function deletelabel(args: { id: Int }): Void {
        var account = Beluga.getInstance().getModuleInstance(Account);

        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
            this.triggers.deleteLabelFail.dispatch({error: TicketUserNotLogged});
        } else {
            if (this.labelExistFromID(args.id)) {
                var label = Label.manager.get(args.id);
                label.delete();
            this.triggers.deleteLabelSuccess.dispatch();
            } else {
                this.error = TicketUndefinedLabelId;
                this.triggers.deleteLabelFail.dispatch({error: TicketUndefinedLabelId});
            }
        }
    }

    public function addlabel(args: { name: String }): Void {
        var account = Beluga.getInstance().getModuleInstance(Account);

        if (!account.isLogged) {
            this.error = TicketUserNotLogged;
            this.triggers.addLabelFail.dispatch({error: TicketUserNotLogged});
        } else if (args.name.length == 0) {
            this.error = TicketLabelEmpty;
            this.triggers.addLabelFail.dispatch({error: TicketLabelEmpty});
        } else {
            if (this.labelExist(args.name)) {
                this.error = TicketLabelAlreadyExist;
                this.triggers.addLabelFail.dispatch({error: TicketLabelAlreadyExist});
            } else {
                this.createNewLabel(args.name);
                this.triggers.addLabelSuccess.dispatch();
            }
        }
    }


    /* Utils functions */

    /// The dynamic content is on the form :
    /// List<{ label_name: String, label_id: Int }>
    public function getLabelsList(): List<Label> {
        var labels: List<Label> = Label.manager.dynamicSearch({});
        return labels;
    }

    /// retrieve the totals count of message for a given ticket
    public function getTicketMessageCount(ticket_id: Int): Int {
        var message_count: Int = 0;

        for( u in Message.manager.search($ticket_id == ticket_id) ) {
            message_count += 1;
        }

        return message_count;
    }

    /// Is the label already in the db or not
    /// use the label name
    public function labelExist(label_name: String): Bool {
        var label = null;
        for( l in Label.manager.search($name == label_name) ) {
            label = l;
        }
        if (label == null) { return false; }
        else { return true; }
    }

    /// Is the label already in the db or not
    /// use the label name
    public function labelExistFromID(label_id: Int): Bool {
        var label = null;
        for( l in Label.manager.search($id == label_id) ) {
            label = l;
        }
        if (label == null) { return false; }
        else { return true; }
    }

    public function createNewLabel(label_name: String): Void {
        var label: Label = new Label();
        label.name = label_name;
        label.insert();
    }

    /// Get all the labels associated to a ticket
    public function getTicketLabels(ticket_id: Int): List<Dynamic> {
        var labels: List<Dynamic> = new List<Dynamic>();

        for( tl in TicketLabel.manager.search($ticket_id == ticket_id) ) {
            labels.push( { label_name: Label.manager.get(tl.label_id).name } );
        }

        return labels;
    }

    /// List of Dynamics is on the form:
    /// { message_content: String, message_creation_date: Date, message_author: String}
    public function getTicketMessages(ticket_id: Int): List<Dynamic> {
        var messages: List<Dynamic> = new List<Dynamic>();

        for( m in Message.manager.search($id == ticket_id) ) {
            messages.push({
                message_content: m.content,
                message_creation_date: m.creation_date,
                message_author: User.manager.get(m.author_id).login,
                message_author_id: m.author_id
            });
        }

        return messages;
    }

}
