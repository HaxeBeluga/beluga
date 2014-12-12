package beluga.module.survey.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.account.Account;
import beluga.widget.Layout;

class MttObject {
    public var name: String;
    public var choice: String;

    public function new(name: String, choice: String) {
        this.name = name;
        this.choice = choice;
    }
}

class Create extends MttWidget<Survey> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/survey/view/tpl/create.mtt");
        super(Survey, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/survey/view/locale/create/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            // here is a trick to replace the Create widget by the Default widget
            var ret = mod.widgets.survey.getContext();

            ret.other = mod.widgets.survey.render();
            return ret;
        }
        var names_and_choices = new Array<MttObject>();

        if (mod.choices != null) {
            var pos = 0;

            for (choice in mod.choices) {
                if (pos > 0)
                    names_and_choices.push(new MttObject("choices" + pos, choice));
                else
                    names_and_choices.push(new MttObject("choices", choice));
                pos += 1;
            }
        }
        return {
            title: mod.title,
            description: mod.description,
            choices: names_and_choices,
            path : "/beluga/survey/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            module_name: "Create survey"
        };
    }
}