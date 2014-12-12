package beluga.module.survey.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;
import beluga.widget.Layout;

class Default extends MttWidget<Survey> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/survey/view/tpl/surveys_list.mtt");
        super(Survey, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/survey/view/locale/default/", mod.i18n);
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
            path : "/beluga/survey/",
            module_name: "Survey default page"
        };
    }
}