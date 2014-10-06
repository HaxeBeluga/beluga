package beluga.module.survey.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;

class Print extends MttWidget<SurveyImpl> {

    public function new(mttfile = "beluga_survey_print_survey.mtt") {
        super(Survey, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/survey/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var choices = mod.getResults(mod.actual_survey_id);

        return {
            survey : mod.getSurvey(mod.actual_survey_id),
            choices : choices,
            path : "/beluga/survey/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg)
        };
    }
}