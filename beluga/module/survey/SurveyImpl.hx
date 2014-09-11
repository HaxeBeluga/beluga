package beluga.module.survey;

import haxe.xml.Fast;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;

import beluga.module.account.model.User;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.SurveyInternal;
import beluga.module.account.Account;
import beluga.module.survey.SurveyData;
import beluga.module.survey.model.SurveyModel;

class SurveyImpl extends ModuleImpl implements SurveyInternal {
    public var triggers = new SurveyTrigger();
    private var error_msg : String;
    private var success_msg : String;

    // User to set back previous form values if it didn't work
    private var title : String;
    private var description : String;
    private var choices : Array<String>;

    public function new() {
        super();
        error_msg = "";
        success_msg = "";
        title = "";
        description = "";
        choices = null;
    }

    override public function initialize(beluga : Beluga) : Void {

    }

    public function getDefaultContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null && error_msg == "") {
            error_msg = "Please log in !";
        }

        return {surveys : this.getSurveysList(), user : user,
            error : error_msg, success : success_msg, path : "/beluga/survey/"};
    }

    public function getRedirectContext() : Dynamic {
        return {path : "/beluga/survey/", error : error_msg, success : success_msg};
    }

    public function getCreateContext() : Dynamic {
        return {title: title, description: description, choices: choices, path : "/beluga/survey/",
            error : error_msg, success : success_msg};
    }

    public function getVoteContext(survey_id: Int) : Dynamic {
        var arr = new Array<Choice>();
        var t = new Array<Choice>();
        for (tmp_c in Choice.manager.dynamicSearch( { survey_id : survey_id } )) {
            if (t.length > 0)
                arr.push(tmp_c);
            else {
                t.push(tmp_c);
            }
        }

        return {survey : this.getSurvey(survey_id), choices : arr, first : t, path : "/beluga/survey/",
            error : error_msg, success : success_msg};
    }

    public function getPrintContext(survey_id: Int) : Dynamic {
        var t_choices = this.getResults({survey_id: survey_id});
        return {survey : this.getSurvey(survey_id), choices : t_choices, path : "/beluga/survey/",
            error : error_msg, success : success_msg};
    }

    public function redirect() {
        this.triggers.redirect.dispatch();
    }

    public function delete(args : {survey_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
        var nb = 0;

        if (user == null) {
            this.triggers.deleteFail.dispatch();
            return;
        }
        for (tmp in SurveyModel.manager.dynamicSearch( {author_id : user.id, id : args.survey_id} )) {
            tmp.delete();
            nb += 1;
        }

        if (nb > 0) {
            success_msg = "Survey has been successfully deleted !";
            this.triggers.deleteSuccess.dispatch();
        } else {
            error_msg = "Survey not found or you can't delete this survey";
            this.triggers.deleteFail.dispatch();
        }
    }

    public function getSurvey(id: Int) : SurveyModel {
        for (tmp in SurveyModel.manager.dynamicSearch( { id : id } )) {
            return tmp;
        }
        return null;
    }

    public function getSurveysList() : Array<SurveyData> {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var m_surveys = new Array<SurveyData>();

        if (user == null)
            return m_surveys;

        for (tmp in SurveyModel.manager.dynamicSearch( { author_id : user.id } )) {
            var tmp_v = new SurveyData();

            tmp_v.m_survey = tmp;

            for (tmp_c in Choice.manager.dynamicSearch( { survey_id : tmp.id } ))
                tmp_v.m_choices.push(tmp_c);
            for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } ))
                tmp_v.m_results.push(tmp_c);

            m_surveys.push(tmp_v);
        }
        return m_surveys;
    }

    public function print(args : {survey_id : Int}) {
        var survey = this.getSurvey(args.survey_id);
        if (survey == null) {
            error_msg = "Unknown survey";
            this.triggers.defaultSurvey.dispatch();
            return;
        }
        this.triggers.printSurvey.dispatch({survey_id: args.survey_id});
    }

    public function getChoices(args : {survey_id : Int}) : Array<Choice> {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var arr = new Array<Choice>();

        if (user != null) {
            for (tmp in SurveyModel.manager.dynamicSearch( {id : args.survey_id} )) {
                for (tmp_c in Choice.manager.dynamicSearch( { survey_id : tmp.id } )) {
                    arr.push(tmp_c);
                }
            }
        }
        return arr;
    }

    public function create(args : {
        title : String,
        description : String,
        choices : Array<String>
    }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            this.triggers.defaultSurvey.dispatch();
            return;
        }
        title = args.title;
        description = args.description;
        choices = args.choices;

        var choices_count = 0;
        if (args.choices != null) {
            for (t_choices in args.choices) {
                if (t_choices != null && t_choices != "")
                    choices_count += 1;
            }
        }
        if (args.choices == null || choices_count < 2) {
            error_msg = "Please enter at least two choices";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.title == "") {
            error_msg = "Please enter a title";
            this.triggers.createFail.dispatch();
            return;
        }
        if (args.description == "") {
            error_msg = "Please enter a description";
            this.triggers.createFail.dispatch();
            return;
        }

        var tmp_choices = new Array<String>();

        if (args.choices != null)
            for (t in args.choices)
                if (t != null && t != "")
                    tmp_choices.push(t);

        if (tmp_choices.length < 2) {
            error_msg = "Error ! Survey has not been created...";
            this.triggers.createFail.dispatch();
            return;
        }

        var survey = new SurveyModel();

        survey.name = args.title;
        survey.author_id = user.id;
        survey.description = args.description;
        survey.multiple_choice = false; // not used for the moment

        survey.insert();
        for (tmp in tmp_choices) {
            var c = new Choice();

            c.label = tmp;
            c.survey_id = survey.id;
            c.insert();
        }
        success_msg = "Survey has been successfully created !";
        this.triggers.createSuccess.dispatch();
    }

    public function vote(args : {
        survey_id : Int,
        option : Int
    }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            error_msg = "You have to be logged to vote !";
            this.triggers.voteFail.dispatch({ survey : args.survey_id });
            return;
        }

        for (tmp in Result.manager.search( { survey_id : args.survey_id, user_id : user.id } )) {
            error_msg = "You already has voted for this survey";
            this.triggers.voteFail.dispatch({ survey : args.survey_id });
            return;
        }

        for (survey in SurveyModel.manager.dynamicSearch( {id : args.survey_id} )) {
            var res = new Result();

            res.survey_id = survey.id;
            res.user_id = user.id;
            res.choice_id = args.option;
            res.insert();

            var notify = {
                title: "New answer to your survey !",
                text: user.login + " has just answer to your survey " + survey.name +
                " <a href=\"/beluga/survey/print?id=" + survey.id + "\">See</a>.",
                user_id: survey.author_id
            };
            this.triggers.answerNotify.dispatch(notify);
            success_msg = "Your vote has been registered";
            this.triggers.voteSuccess.dispatch();
            return;
        }
        error_msg = "Survey not found";
        this.triggers.voteFail.dispatch({ survey : args.survey_id });
    }


    public function canVote(args : {survey_id : Int}) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (tmp in SurveyModel.manager.dynamicSearch( {id : args.survey_id} )) {
                for (tmp_c in Result.manager.dynamicSearch( { survey_id : tmp.id, user_id : user.id } )) {
                    return false;
                }
                return true;
            }
        }
        return false;
    }

    public function getResults(args : {survey_id : Int}) : Array<Dynamic> {
        var arr = new Array<Dynamic>();
        var t_choices = new Array<Dynamic>();
        var tot = 0;

        for (tmp_r in Result.manager.dynamicSearch( { survey_id : args.survey_id } )) {
            tot += 1;
            var found = false;
            for (t in arr) {
                if (t.id == tmp_r.choice_id) {
                    t.pourcent += 1;
                    found = true;
                }
            }
            if (found == false)
                arr.push({id : tmp_r.choice_id, pourcent : 1});
        }
        for (tmp_c in Choice.manager.dynamicSearch( { survey_id : args.survey_id } )) {
            var done = false;
            for (tmp in arr) {
                if (tmp.id == tmp_c.id) {
                    t_choices.push({choice : tmp_c, pourcent : tmp.pourcent * 100.0 / tot, vote : tmp.pourcent});
                    done = true;
                }
            }
            if (done == false) {
                t_choices.push({choice : tmp_c, pourcent : 0, vote : 0});
            }
        }
        return t_choices;
    }
}