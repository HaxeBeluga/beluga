package beluga.module.survey.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;

class Create extends MttWidget<SurveyImpl> {

    public function new(mttfile = "beluga_survey_create.mtt") {
        super(Survey, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/survey/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            // here is a trick to replace the Create widget by the Default widget
            var ret = mod.widgets.survey.getContext();

            ret.other = mod.widgets.survey.render();
            return ret;
        }
        return {
            title: mod.title,
            description: mod.description,
            choices: mod.choices,
            path : "/beluga/survey/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg)
        };
    }
}