package beluga.module.ticket;

enum TicketErrorKind {
    TicketUserNotLogged;
    TicketMessageEmpty;
    TicketTitleEmpty;
    TicketUndefinedLabelId;
    TicketLabelEmpty;
    TicketLabelAlreadyExist;
    TicketErrorNone;
}