package beluga.module.survey;

import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.model.SurveyModel;

class SurveyData {
    public var m_survey : SurveyModel;
    public var m_choices : Array<Choice>;
    public var m_results : Array<Result>;

    public function new() {
        m_results = new Array<Result>();
        m_choices = new Array<Choice>();
        m_survey = null;
    }
}