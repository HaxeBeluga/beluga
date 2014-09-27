package beluga.module.survey.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.core.BelugaI18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;

class Default extends MttWidget<SurveyImpl> {

    public function new(mttfile = "beluga_survey_surveys_list.mtt") {
        super(Survey, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/survey/view/locale/default/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null && mod.error_id == None) {
            mod.error_id = MissingLogin;
        }

        return {
            surveys : mod.getSurveysList(),
            user : user,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/survey/"
        };
    }
}