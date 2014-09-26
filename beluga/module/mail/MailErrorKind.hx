package beluga.module.mail;

enum MailErrorKind {
    MissingLogin;
    MailNotSent;
    OnlyPHP;
    MissingReceiver;
    MissingSubject;
    MissingMessage;
    UnknownId;
    None;
}