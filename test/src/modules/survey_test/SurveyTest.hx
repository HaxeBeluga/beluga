package modules.survey_test;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.survey.Survey;
import beluga.module.survey.model.SurveyModel;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.notification.Notification;
import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class SurveyTest {
    public var beluga(default, null) : Beluga;
    public var survey(default, null) : Survey;
    private var error_msg : String;
    private var success_msg : String;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.survey = beluga.getModuleInstance(Survey);
        this.survey.triggers.defaultSurvey.add(this.doDefault);
        this.survey.triggers.redirect.add(this.doRedirectPage);
        this.survey.triggers.createFail.add(this.doCreateFail);
        this.survey.triggers.createSuccess.add(this.doCreateSuccess);
        this.survey.triggers.deleteFail.add(this.doDeleteFail);
        this.survey.triggers.deleteSuccess.add(this.doDeleteSuccess);
        this.survey.triggers.voteFail.add(this.doVoteFail);
        this.survey.triggers.voteSuccess.add(this.doVoteSuccess);
        this.survey.triggers.printSurvey.add(this.doPrintPage);
        this.survey.triggers.answerNotify.add(this.doAnswerNotify);
        this.error_msg = "";
        this.success_msg = "";
    }

    public function doDefault() {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        if (user == null) {
            error_msg = "Please log in !";
        }
        var widget = survey.getWidget("surveys_list");
        widget.context = {surveys : survey.getSurveysList(), user : user,
            error : error_msg, success : success_msg, path : "/beluga/survey/"};

        var surveyWidget = widget.render();

        var html = Renderer.renderDefault("page_survey", "Surveys list", {
            surveyWidget: surveyWidget
        });
        Sys.print(html);
    }

    public function doRedirectPage() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }
        var widget = survey.getWidget("create");
        widget.context = {path : "/beluga/survey/"};

        var surveyWidget = widget.render();

        var html = Renderer.renderDefault("page_survey", "Create survey", {
            surveyWidget: surveyWidget
        });
        Sys.print(html);
    }

    public function doCreateFail() {
        error_msg = "Error ! Survey has not been created...";
        this.doDefault();
    }

    public function doCreateSuccess() {
        success_msg = "Survey has been successfully created !";
        this.doDefault();
    }

    public function doDeleteSuccess() {
        success_msg = "Survey has been successfully deleted !";
        this.doDefault();
    }

    public function doDeleteFail() {
        error_msg = "Error when trying to delete survey...";
        this.doDefault();
    }

    public function doCreatePage() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }
        var widget = survey.getWidget("create");
        widget.context = {path : "/beluga/survey/"}

        var createWidget = widget.render();
        var html = Renderer.renderDefault("page_survey", "Create", {
            surveyWidget: createWidget
        });
        Sys.print(html);
    }

     public function doVoteSuccess() {
        success_msg = "Your vote has been registered";
        this.doDefault();
    }

    public function doVoteFail(args : {err : String}) {
        error_msg = args.err;
        this.doDefault();
     }

    public function doVotePage(args : {survey : SurveyModel}) {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged == false) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }

        var arr = new Array<Choice>();
        var t = new Array<Choice>();
        for (tmp_c in Choice.manager.dynamicSearch( { survey_id : args.survey.id } )) {
            if (t.length > 0)
                arr.push(tmp_c);
            else {
                t.push(tmp_c);
            }
        }

        var widget = survey.getWidget("vote");
        widget.context = {survey : args.survey, choices : arr, first : t, path : "/beluga/survey/"};

        var subscribeWidget = widget.render();
        var html = Renderer.renderDefault("page_survey", "Vote page", {
            surveyWidget: subscribeWidget
        });
        Sys.print(html);
    }

    public function doPrintPage(args : {survey_id : Int}) {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged == false) {
            error_msg = "Please log in !";
            doDefault();
            return;
        }
        var survey = this.survey.getSurvey(args.survey_id);
        if (survey == null) {
            error_msg = "Unknown survey";
            doDefault();
            return;
        }
        if (this.survey.canVote({survey_id : args.survey_id})) {
            doVotePage({survey : survey});
            return;
        }
        var choices = this.survey.getResults({survey_id: args.survey_id});
        var widget = this.survey.getWidget("print_survey");
        widget.context = {survey : survey, choices : choices, path : "/beluga/survey/"};

        var surveyWidget = widget.render();

        var html = Renderer.renderDefault("page_survey", "Display survey", {
            surveyWidget: surveyWidget
        });
        Sys.print(html);
    }

    public function doAnswerNotify(args : {title : String, text : String, user_id: Int}) {
        var notification = Beluga.getInstance().getModuleInstance(Notification);
        notification.create(args);
    }
}