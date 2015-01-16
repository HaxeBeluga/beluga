package beluga.module.survey.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.account.Account;
import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.survey.model.Choice;
import beluga.widget.Layout;

class Vote extends MttWidget<Survey> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/survey/view/tpl/vote.mtt");
        super(Survey, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/survey/view/locale/vote/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged == false || !mod.canVote(mod.actual_survey_id)) {
            // here is a trick to replace the Vote widget by the Print widget
            var ret = mod.widgets.print.getContext();

            ret.vote = mod.widgets.print.render();
            return ret;
        }
        var choice_array = new Array<Choice>();
        var first = new Array<Choice>();

        for (choice in Choice.manager.dynamicSearch({survey_id : mod.actual_survey_id})) {
            if (first.length > 0)
                choice_array.push(choice);
            else {
                first.push(choice);
            }
        }

        return {
            survey : mod.getSurvey(mod.actual_survey_id),
            choices : choice_array,
            first : first,
            path : "/beluga/survey/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            module_name: "Survey vote"
        };
    }
}