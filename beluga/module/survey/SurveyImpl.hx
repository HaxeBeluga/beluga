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

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) : Void {

    }

    public function redirect() {
        this.triggers.redirect.dispatch();
    }

	#if (php || neko)	

    public function delete(args : {survey_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
        var nb = 0;

        if (user == null)
            return;
        for (tmp in SurveyModel.manager.dynamicSearch( {author_id : user.id, id : args.survey_id} )) {
            tmp.delete();
            nb += 1;
        }

        if (nb > 0) {
            this.triggers.deleteSuccess.dispatch();
        } else {
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
	#end

    public function print(args : {survey_id : Int}) {
        this.triggers.printSurvey.dispatch({survey_id: args.survey_id});
    }

	#if (php || neko)
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

        if (user == null || args.choices == null || args.choices.length < 2 || args.title == "") {
            this.triggers.createFail.dispatch();
            return;
        }

        var tmp_choices = new Array<String>();

        if (args.choices != null)
            for (t in args.choices)
                if (t != null && t != "")
                    tmp_choices.push(t);

        if (tmp_choices.length < 2) {
            this.triggers.createFail.dispatch();
            return;
        }

        var survey = new SurveyModel();

        survey.name = args.title;
        survey.author_id = user.id;
        survey.description = args.description;
        survey.multiple_choice = args.choices != null ? args.choices.length : 0;

        survey.insert();
        for (tmp in tmp_choices) {
            var c = new Choice();

            c.label = tmp;
            c.survey_id = survey.id;
            c.insert();
        }
        this.triggers.createSuccess.dispatch();
    }

    public function vote(args : {
        survey_id : Int,
        option : Int
    }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            this.triggers.voteFail.dispatch({err: "You have to be logged to vote !"});
            return;
        }

        for (tmp in Result.manager.search( { survey_id : args.survey_id, user_id : user.id } )) {
            this.triggers.voteFail.dispatch({err: "You already has voted for this survey"});
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
            this.triggers.voteSuccess.dispatch();
            return;
        }
        this.triggers.voteFail.dispatch({err: "Survey not found"});
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
	#end

    public function getResults(args : {survey_id : Int}) : Array<Dynamic> {
        var arr = new Array<Dynamic>();
        var choices = new Array<Dynamic>();
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
                    choices.push({choice : tmp_c, pourcent : tmp.pourcent * 100.0 / tot, vote : tmp.pourcent});
                    done = true;
                }
            }
            if (done == false) {
                choices.push({choice : tmp_c, pourcent : 0, vote : 0});
            }
        }
        return choices;
    }
}