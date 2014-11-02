// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

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