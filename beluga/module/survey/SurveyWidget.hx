package beluga.module.survey;

import beluga.module.survey.widget.Default;
import beluga.module.survey.widget.Create;
import beluga.module.survey.widget.Vote;
import beluga.module.survey.widget.Print;

class SurveyWidget {
    public var survey = new Default();
    public var create = new Create();
    public var vote = new Vote();
    public var print = new Print();

    public function new() {}
}