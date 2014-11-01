package beluga.module.faq;

enum FaqErrorKind {
    UnknownCategory;
    MissingQuestion;
    MissingAnswer;
    MissingName;
    MissingLogin;
    EntryAlreadyExists;
    CategoryAlreadyExists;
    IdNotFound;
    None;
}