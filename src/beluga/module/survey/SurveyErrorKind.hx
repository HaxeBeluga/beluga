package beluga.module.survey;

enum SurveyErrorKind {
    MissingLogin;
    NotAllowed;
    MissingDescription;
    MissingTitle;
    MissingChoices;
    NotFound;
    AlreadyVoted;
    None;
}