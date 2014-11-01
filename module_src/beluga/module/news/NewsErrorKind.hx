package beluga.module.news;

enum NewsErrorKind {
    MissingLogin;
    NewsNotFound;
    CommentNotFound;
    NotAllowed;
    MissingMessage;
    MissingTitle;
    None;
}