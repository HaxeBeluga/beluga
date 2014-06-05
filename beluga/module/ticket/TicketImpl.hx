package beluga.module.ticket;

// Beluga core
import beluga.core.module.ModuleImpl;
import beluga.core.Beluga;
import beluga.core.macro.MetadataReader;

// Beluga mods
import beluga.module.account.model.User;
import beluga.module.ticket.model.TicketModel;
import beluga.module.ticket.model.Label;
import beluga.module.ticket.model.Message;
import beluga.module.ticket.model.TicketLabel;
import beluga.module.ticket.model.Assignement;
import beluga.module.account.Account;
import sys.db.Manager;

// Haxe
import haxe.xml.Fast;

class TicketImpl extends ModuleImpl implements TicketInternal implements MetadataReader {
    private var show_id: Int = 0;
    // FIXME: change this for an enum or whatever, just used to disply an error message if the user is no logged.
    private var error: String = "";

    public function new() {
        super();
    }

    override public function loadConfig(data : Fast): Void {

    }

    /** Actions trigger **/

    @bTrigger("beluga_ticket_browse")
    public static function _browse(): Void {
        Beluga.getInstance().getModuleInstance(Ticket).browse();
    }

    public function browse(): Void{
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_browse", []);
    }

    /// Set the context informations for the browse widget:
    /// * Tickets informations
    /// * closed / open tickets
    /// * Existings labels
    public function getBrowseContext(): Dynamic {
        var tickets: List<Dynamic> = new List<Dynamic>();
        var labels: List<Dynamic> = new List<Dynamic>();
        var open: Int = 0;
        var closed: Int = 0;
        var status: String = "open";
        var message_count: Int = 0;

        // Store all tickets in a Dynamic
        var row = Manager.cnx.request("SELECT * from beluga_tic_ticket ORDER BY ti_date DESC");
        for (t in row) {
            // retrieve ticket status
            if (t.ti_status == 1) { status = "open"; }
            else { status = "closed"; }

            // retrieve message count for this ticket
            message_count = this.getTicketMessageCount(t.ti_id);

            // insert tickets data
            tickets.push({
                ticket_owner: User.manager.get(t.ti_us_id).login,
                ticket_owner_id: User.manager.get(t.ti_us_id).id,
                ticket_subject: t.ti_title,
                ticket_date: t.ti_date,
                ticket_id: t.ti_id,
                ticket_status: status,
                ticket_comments_count: message_count
            });

            // count closed / open tickets
            if (t.ti_status == 1) { open += 1; }
            else { closed += 1; }

            message_count = 0;
        }

        // Store all labels names in a dynamic
        labels = getLabelsList();

        return {
            tickets_list: tickets,
            labels_list: labels,
            open_tickets: open,
            closed_tickets: closed
        };
    }

    @bTrigger("beluga_ticket_create")
    public static function _create(): Void {
        Beluga.getInstance().getModuleInstance(Ticket).create();
    }

    public function create(): Void {
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_create", []);
    }

    /// Return the context for the view create ticket
    /// in the form of a List<Dynamic>
    /// { labels_list: { label_name: String }, ticket_error: String }
    public function getCreateContext(): Dynamic {
        var labels: List<Dynamic> = new List<Dynamic>();
        var users: List<Dynamic> = new List<Dynamic>();

        // Store all labels names in a dynamic
        for (l in Label.manager.search($la_id < 100)) {
            labels.push({ label_name: l.la_name });
        }
        for (u in User.manager.search($id < 100)) {
            users.push({
                user_name: u.login,
                user_id: u.id
            });
        }

        return {
            labels_list: labels,
            ticket_error: this.error,
            users_list: users
        };
    }

    @bTrigger("beluga_ticket_show")
    public static function _show(args: { id: Int }): Void  {
        Beluga.getInstance().getModuleInstance(Ticket).show(args);
    }

    public function show(args: { id: Int }): Void {
        this.show_id = args.id;
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [args]);
    }

    /// Create the context for the Show view:
    /// * retrieve all the tickets data +
    /// * all the comments associated to the ticket
    /// * then all the labels associated to the tickets
    public function getShowContext(): Dynamic {
        var ticket = TicketModel.manager.get(this.show_id);
        var messages: List<Dynamic> = new List<Dynamic>();
        var labels: List<Dynamic> = new List<Dynamic>();
        var assignee: String = "None";

        // retrieve messages informations
        messages = this.getTicketMessages(ticket.ti_id);

        // retrieve associated labels
        labels = this.getTicketLabels(ticket.ti_id);

        var assignement = Assignement.manager.search($as_ti_id == ticket.ti_id).first();
        if (assignement != null) {
            assignee = User.manager.get(assignement.as_us_id).login;
        }

        return {
            ticket_subject: ticket.ti_title,
            ticket_id: ticket.ti_id,
            ticket_message: ticket.ti_content,
            ticket_create_date: ticket.ti_date,
            ticket_owner: User.manager.get(ticket.ti_us_id).login,
            ticket_message_count: messages.length,
            messages_list: messages,
            labels_list: labels,
            ticket_status: ticket.ti_status,
            ticket_error: this.error,
            ticket_assignee: assignee,
            ticket_owner_id: User.manager.get(ticket.ti_us_id).id
        };
    }

    @bTrigger("beluga_ticket_reopen")
    public static function _reopen(args: { id: Int }): Void  {
        Beluga.getInstance().getModuleInstance(Ticket).reopen(args);
    }

    /// Just get the id of the ticket, then reopen it
    /// FIXME: Check if the user is logged then reopen else error message
    public function reopen(args: { id: Int }): Void {
        this.show_id = args.id;

         // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged()) {
            this.error = "You must be logged to reopen a ticket !";
        } else {
            var ticket = TicketModel.manager.get(args.id);
            ticket.ti_status = 1;
            ticket.update();
        }
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [args]);
    }

    @bTrigger("beluga_ticket_close")
    public static function _close(args: { id: Int }): Void  {
        Beluga.getInstance().getModuleInstance(Ticket).close(args);
    }

    /// Just get the id of the ticket, then close it
    /// FIXME: Check if the user is logged then closes else error message
    public function close(args: { id: Int }): Void {
        this.show_id = args.id;

        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged()) {
            this.error = "You must be logged to close a ticket !";
        } else {
            var ticket = TicketModel.manager.get(args.id);
            ticket.ti_status = 0;
            ticket.update();
        }
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [args]);
    }

    @bTrigger("beluga_ticket_comment")
    public static function _comment(args: {
        id: Int,
        message: String
    }): Void  {
        Beluga.getInstance().getModuleInstance(Ticket).comment(args);
    }

    public function comment(args: {
        id: Int,
        message: String
    }): Void  {
        this.show_id = args.id;

        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        if (!account.isLogged()) {
            this.error = "You must be logged to create a ticket !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [{ id: args.id }]);
        } else if (args.message.length == 0) {
            this.error = "Your message cannot be empty !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [{ id: args.id }]);
        } else {
            var message: Message = new Message();
            message.me_content = args.message;
            message.me_us_id_author = account.getLoggedUser().id;
            message.me_date_creation = Date.now();
            message.me_ti_id = args.id;
            message.insert();
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", [{ id: args.id }]);
            this.notifyTicketComment(args.id);
        }
    }

    public function notifyTicketComment(ticket_id: Int) {
        var ticket = TicketModel.manager.search($ti_id == ticket_id).first();
        var notify = {
            title: "New comment !",
            text: "Someone post a new comment to your ticket: " + ticket.ti_title +
            " <a href=\"/beluga/ticket/show?id=" + ticket_id + "\">See</a>" +  ".",
            user_id: ticket.ti_us_id
        };
        beluga.triggerDispatcher.dispatch("beluga_ticket_assign_notify", [notify]);
    }

    @bTrigger("beluga_ticket_submit")
    public static function _submit(args: {
        title: String,
        message: String,
        assignee: String
    }): Void {
        Beluga.getInstance().getModuleInstance(Ticket).submit(args);
    }

    public function submit(args: {
        title: String,
        message: String,
        assignee: String
    }): Void {
        // first check if the user is logged
        var account = Beluga.getInstance().getModuleInstance(Account);
        var ticket = new TicketModel();
        if (!account.isLogged()) {
            this.error = "You must be logged to create a ticket !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_create", []);
        } else if (args.title.length == 0) {
            this.error = "Your title cannot be empty !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_create", []);
        } else {
            ticket.ti_us_id = account.getLoggedUser().id;
            ticket.ti_date = Date.now();
            ticket.ti_title = args.title;
            ticket.ti_content = args.message;
            ticket.ti_status = 1;
            ticket.insert();
            var ticket_id: Int = ticket.ti_id;
            this.show_id = ticket_id;
            if (User.manager.search($login == args.assignee).first() != null) {
                var assignement = new Assignement();
                assignement.as_us_id =  User.manager.search($login == args.assignee).first().id;
                assignement.as_ti_id = ticket.ti_id;
                assignement.insert();
                var args = {
                    title: "Ticket assignnment: " + args.title + " !",
                    text: "You've been assigned to the ticket number " + ticket_id + ", " +
                    args.title + " by " + account.getLoggedUser().login +
                    " <a href=\"/beluga/ticket/show?id=" + ticket_id + "\">See</a>" + ".",
                    user_id: assignement.as_us_id
                };
                beluga.triggerDispatcher.dispatch("beluga_ticket_assign_notify", [args]);
            }
            beluga.triggerDispatcher.dispatch("beluga_ticket_show_show", []);
        }
    }

    @bTrigger("beluga_ticket_admin")
    public static function _admin(): Void {
        Beluga.getInstance().getModuleInstance(Ticket).admin();
    }

    public function admin(): Void {
        beluga.triggerDispatcher.dispatch("beluga_ticket_show_admin", []);
        // beluga.triggerDispatcher.dispatch("beluga_ticket_addlabel_success", []);
    }

    /// return the context for the admin widget in the form of a List<Dynamic>
    /// { admin_error: String, labels_list: { label_name: String, label_id: Int } }
    public function getAdminContext(): Dynamic {
        return {
            admin_error: this.error,
            labels_list: this.getLabelsList()
        };
    }

    @bTrigger("beluga_ticket_deletelabel")
    public static function _deletelabel(args: { id: Int }): Void {
        Beluga.getInstance().getModuleInstance(Ticket).deletelabel(args);
    }

    public function deletelabel(args: { id: Int }): Void {
        var account = Beluga.getInstance().getModuleInstance(Account);

        if (!account.isLogged()) {
            this.error = "You must be logged to delete a label !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_deletelabel_fail", []);
        } else {
            if (this.labelExistFromID(args.id)) {
                var label = Label.manager.get(args.id);
                label.delete();
                beluga.triggerDispatcher.dispatch("beluga_ticket_deletelabel_success", []);
            } else {
                this.error = "There is no existing label with the given id !";
                beluga.triggerDispatcher.dispatch("beluga_ticket_deletelabel_fail", []);
            }
        }
    }

    @bTrigger("beluga_ticket_addlabel")
    public static function _addlabel(args: { name: String }): Void {
        Beluga.getInstance().getModuleInstance(Ticket).addlabel(args);
    }

    public function addlabel(args: { name: String }): Void {
        var account = Beluga.getInstance().getModuleInstance(Account);

        if (!account.isLogged()) {
            this.error = "You must be logged to add a label !";
            beluga.triggerDispatcher.dispatch("beluga_ticket_addlabel_fail", []);
        } else if (args.name.length == 0) {
            this.error = "Your label cannot be empty!";
            beluga.triggerDispatcher.dispatch("beluga_ticket_addlabel_fail", []);
        } else {
            if (this.labelExist(args.name)) {
                this.error = "This label already exist!";
                beluga.triggerDispatcher.dispatch("beluga_ticket_addlabel_fail", []);
            } else {
                this.createNewLabel(args.name);
                beluga.triggerDispatcher.dispatch("beluga_ticket_addlabel_success", []);
            }
        }
    }


    /* Utils functions */

    /// The dynamic content is on the form :
    /// List<{ label_name: String, label_id: Int }>
    public function getLabelsList(): List<Dynamic> {
        var labels: List<Dynamic> = new List<Dynamic>();

        for (l in Label.manager.search($la_id < 100)) {
            labels.push({
                label_name: l.la_name,
                label_id: l.la_id
            });
        }

        return labels;
    }

    /// retrieve the totals count of message for a given ticket
    public function getTicketMessageCount(ticket_id: Int): Int {
        var message_count: Int = 0;

        for( u in Message.manager.search($me_ti_id == ticket_id) ) {
                message_count += 1;
        }

        return message_count;
    }

    /// Is the label already in the db or not
    /// use the label name
    public function labelExist(label_name: String): Bool {
        var label = null;
        for( l in Label.manager.search($la_name == label_name) ) {
            label = l;
        }
        if (label == null) { return false; }
        else { return true; }
    }

    /// Is the label already in the db or not
    /// use the label name
    public function labelExistFromID(label_id: Int): Bool {
        var label = null;
        for( l in Label.manager.search($la_id == label_id) ) {
            label = l;
        }
        if (label == null) { return false; }
        else { return true; }
    }

    public function createNewLabel(label_name: String): Void {
        var label: Label = new Label();
        label.la_name = label_name;
        label.insert();
    }

    /// Get all the labels associated to a ticket
    public function getTicketLabels(ticket_id: Int): List<Dynamic> {
        var labels: List<Dynamic> = new List<Dynamic>();

        for( tl in TicketLabel.manager.search($tl_ticket_id == ticket_id) ) {
            labels.push( { label_name: Label.manager.get(tl.tl_label_id).la_name } );
        }

        return labels;
    }

    /// List of Dynamics is on the form:
    /// { message_content: String, message_creation_date: Date, message_author: String}
    public function getTicketMessages(ticket_id: Int): List<Dynamic> {
        var messages: List<Dynamic> = new List<Dynamic>();
        
        for( m in Message.manager.search($me_ti_id == ticket_id) ) {
            messages.push({
                message_content: m.me_content,
                message_creation_date: m.me_date_creation,
                message_author: User.manager.get(m.me_us_id_author).login,
                message_author_id: m.me_us_id_author
            });
        }

        return messages;
    }

}
