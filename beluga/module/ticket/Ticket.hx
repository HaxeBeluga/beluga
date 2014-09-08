package beluga.module.ticket;

import beluga.core.module.Module;

interface Ticket extends Module {
    public var triggers: TicketTrigger;
    public var widgets : TicketWidget;

    public function browse(): Void;
    public function create(): Void;
    public function show(args: { id: Int }): Void;
    public function reopen(args: { id: Int }): Void;
    public function close(args: { id: Int }): Void;
    public function comment(args: { id: Int, message: String }): Void;
    public function submit(args: { title: String, message: String, assignee: String }): Void;
    public function admin(): Void;
    public function deletelabel(args: { id: Int }): Void;
    public function addlabel(args: { name: String }): Void;
    public function getBrowseContext(): Dynamic;
    public function getCreateContext(): Dynamic;
    public function getShowContext(): Dynamic;
    public function getAdminContext(): Dynamic;

    public function getLabelsList(): List<Dynamic>;
    public function getTicketMessageCount(ticket_id: Int): Int;
    public function labelExist(label_name: String): Bool;
    public function labelExistFromID(label_id: Int): Bool;
    public function createNewLabel(label_name: String): Void;
    public function getTicketLabels(ticket_id: Int): List<Dynamic>;
    public function getTicketMessages(ticket_id: Int): List<Dynamic>;
}