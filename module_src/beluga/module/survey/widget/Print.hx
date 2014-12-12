package beluga.module.survey.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;
import beluga.widget.Layout;

class Print extends MttWidget<Survey> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/survey/view/tpl/print_survey.mtt");
        super(Survey, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/survey/view/locale/print/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var choices = mod.getResults(mod.actual_survey_id);

        return {
            survey : mod.getSurvey(mod.actual_survey_id),
            choices : choices,
            path : "/beluga/survey/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            module_name: "Print survey"
        };
    }
}