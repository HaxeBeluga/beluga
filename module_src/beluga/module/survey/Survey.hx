// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.survey;

import beluga.module.survey.api.SurveyApi;
import haxe.xml.Fast;

import beluga.Beluga;
import beluga.module.Module;
import beluga.I18n;

import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.survey.SurveyData;
import beluga.module.survey.model.SurveyModel;
import beluga.module.survey.SurveyWidget;
import beluga.module.survey.SurveyErrorKind;

import beluga.module.survey.js.Javascript;

class Survey extends Module {
    public var triggers = new SurveyTrigger();
    public var error_id : SurveyErrorKind;
    public var success_msg : String;
    public var actual_survey_id : Int;

    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/survey/locale/");
    public var widgets: SurveyWidget;

    // User to set back previous form values if it didn't work
    public var title : String;
    public var description : String;
    public var choices : Array<String>;

    public function new() {
        super();
        error_id = None;
        success_msg = "";
        title = "";
        description = "";
        choices = null;
        actual_survey_id = -1;
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new SurveyWidget();
        beluga.api.register("survey", new SurveyApi(beluga, this));        
    }

    public function redirect() {
        this.triggers.redirect.dispatch();
    }

    public function getActualSurveyId() : Int {
        return this.actual_survey_id;
    }

    public function delete(survey_id : Int) {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
        var nb = 0;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.deleteFail.dispatch({error : error_id});
            return;
        }
        for (survey in SurveyModel.manager.dynamicSearch({id : survey_id})) {
            if (survey.author_id == user.id || user.isAdmin) {
                // We remove all the choices fields
                for (choice in Choice.manager.dynamicSearch({survey_id : survey_id})) {
                    choice.delete();
                }
                // Then we remove all the results
                for (result in Result.manager.dynamicSearch({survey_id : survey_id})) {
                    result.delete();
                }
                // And we finally remove the survey
                survey.delete();
                success_msg = "survey_delete_success";
                this.triggers.deleteSuccess.dispatch();
            } else {
                error_id = NotAllowed;
                this.triggers.deleteFail.dispatch({error : error_id});
            }
            return;
        }
        error_id = NotFound;
        this.triggers.deleteFail.dispatch({error : error_id});
    }

    public function getSurvey(id: Int) : SurveyModel {
        for (survey in SurveyModel.manager.dynamicSearch({id : id})) {
            return survey;
        }
        return null;
    }

    // Returns all the surveys created by the user
    public function getSurveysList() : Array<SurveyData> {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var surveys_array = new Array<SurveyData>();

        if (user != null) {
            for (survey in SurveyModel.manager.dynamicSearch({author_id : user.id})) {
                var survey_data = new SurveyData();

                survey_data.m_survey = survey;

                for (choice in Choice.manager.dynamicSearch({survey_id : survey.id}))
                    survey_data.m_choices.push(choice);
                for (choice in Result.manager.dynamicSearch({survey_id : survey.id}))
                    survey_data.m_results.push(choice);

                surveys_array.push(survey_data);
            }
        }
        return surveys_array;
    }

    public function print(survey_id : Int) {
        var survey = this.getSurvey(survey_id);

        this.actual_survey_id = survey_id;
        if (survey == null) {
            error_id = NotFound;
            this.triggers.defaultSurvey.dispatch();
        } else {
            this.triggers.printSurvey.dispatch();
        }
    }

    // Returns the different choices for the specified Survey
    public function getChoices(survey_id : Int) : Array<Choice> {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var choices_array = new Array<Choice>();

        if (user != null) {
            for (survey in SurveyModel.manager.dynamicSearch({id : survey_id})) {
                for (choice in Choice.manager.dynamicSearch({survey_id : survey.id})) {
                    choices_array.push(choice);
                }
            }
        }
        return choices_array;
    }

    public function create(args : {
        title : String,
        description : String,
        choices : Array<String>
    }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.defaultSurvey.dispatch();
            return;
        }
        title = args.title;
        description = args.description;
        choices = args.choices;

        if (args.title == "") {
            error_id = MissingTitle;
            this.triggers.createFail.dispatch({error : error_id});
            return;
        }
        if (args.description == "") {
            error_id = MissingDescription;
            this.triggers.createFail.dispatch({error : error_id});
            return;
        }

        var choices_array = new Array<String>();

        if (args.choices != null)
            for (choice in args.choices)
                if (choice != "")
                    choices_array.push(choice);

        if (choices_array.length < 2) {
            error_id = MissingChoices;
            this.triggers.createFail.dispatch({error : error_id});
            return;
        }

        var survey = new SurveyModel();

        survey.name = args.title;
        survey.author_id = user.id;
        survey.description = args.description;
        survey.multiple_choice = false; // not used for the moment

        survey.insert();
        for (choice in choices_array) {
            var new_choice = new Choice();

            new_choice.label = choice;
            new_choice.survey_id = survey.id;
            new_choice.insert();
        }
        success_msg = "survey_create_success";
        this.triggers.createSuccess.dispatch();
    }

    public function vote(args : {
        survey_id : Int,
        option : Int
    }) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        
        this.actual_survey_id = args.survey_id;
        if (user == null) {
            error_id = MissingLogin;
            this.triggers.voteFail.dispatch({error : error_id});
            return;
        }

        for (result in Result.manager.search({survey_id : args.survey_id, user_id : user.id})) {
            error_id = AlreadyVoted;
            this.triggers.voteFail.dispatch({error : error_id});
            return;
        }

        for (survey in SurveyModel.manager.dynamicSearch({id : args.survey_id})) {
            var result = new Result();

            result.survey_id = survey.id;
            result.user_id = user.id;
            result.choice_id = args.option;
            result.insert();

            var notify = {
                title: "New answer to your survey !",
                text: user.login + " has just answer to your survey " + survey.name +
                ", <a href=\"/beluga/survey/print?id=" + survey.id + "\">see</a>.",
                user_id: survey.author_id
            };
            this.triggers.answerNotify.dispatch(notify);
            success_msg = "vote_success";
            this.triggers.voteSuccess.dispatch();
            return;
        }
        error_id = NotFound;
        this.triggers.voteFail.dispatch({error : error_id});
    }


    public function canVote(survey_id : Int) : Bool {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user != null) {
            for (survey in SurveyModel.manager.dynamicSearch({id : survey_id})) {
                for (result in Result.manager.dynamicSearch({survey_id : survey.id, user_id : user.id})) {
                    return false;
                }
                return true;
            }
        }
        return false;
    }

    // Returns an array containing stats of the specified survey
    public function getResults(survey_id : Int) : Array<Dynamic> {
        var results_array = new Array<Dynamic>();
        var choices_array = new Array<Dynamic>();
        var total = 0;

        for (result in Result.manager.dynamicSearch({survey_id : survey_id})) {
            var found = false;

            total += 1;
            for (result_from_array in results_array) {
                if (result_from_array.id == result.choice_id) {
                    result_from_array.pourcent += 1;
                    found = true;
                }
            }
            if (found == false)
                results_array.push({id : result.choice_id, pourcent : 1});
        }
        for (choice in Choice.manager.dynamicSearch({survey_id : survey_id})) {
            var done = false;

            for (result in results_array) {
                if (result.id == choice.id) {
                    choices_array.push({choice : choice, pourcent : result.pourcent * 100.0 / total, vote : result.pourcent});
                    done = true;
                }
            }
            if (done == false) {
                choices_array.push({choice : choice, pourcent : 0, vote : 0});
            }
        }
        return choices_array;
    }

    public function getErrorString(error: SurveyErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case MissingDescription: BelugaI18n.getKey(this.i18n, "missing_description");
            case MissingTitle: BelugaI18n.getKey(this.i18n, "missing_title");
            case MissingChoices: BelugaI18n.getKey(this.i18n, "missing_choices");
            case NotFound: BelugaI18n.getKey(this.i18n, "not_found");
            case AlreadyVoted: BelugaI18n.getKey(this.i18n, "already_voted");
            case NotAllowed: BelugaI18n.getKey(this.i18n, "not_allowed");
            case None: null;
        };
    }
}