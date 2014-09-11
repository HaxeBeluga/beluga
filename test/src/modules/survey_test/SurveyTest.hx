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

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.survey = beluga.getModuleInstance(Survey);

        this.survey.triggers.defaultSurvey.add(this.doDefault);
        this.survey.triggers.createSuccess.add(this.doDefault);
        this.survey.triggers.redirect.add(this.doRedirectPage);
        this.survey.triggers.createFail.add(this.doCreatePage);
        this.survey.triggers.deleteFail.add(this.doDefault);
        this.survey.triggers.voteFail.add(this.doVotePage);
        this.survey.triggers.printSurvey.add(this.doPrintPage);
        this.survey.triggers.answerNotify.add(this.doAnswerNotify);
    }

    public function doDefault() {
        var widget = survey.getWidget("surveys_list");
        widget.context = survey.getDefaultContext();

        var html = Renderer.renderDefault("page_survey", "Surveys list", {
            surveyWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doRedirectPage() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            doDefault();
            return;
        }
        var widget = survey.getWidget("create");
        widget.context = survey.getRedirectContext();

        var html = Renderer.renderDefault("page_survey", "Create survey", {
            surveyWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doDeleteFail() {
        this.doDefault();
    }

    public function doCreatePage() {
        if (Beluga.getInstance().getModuleInstance(Account).loggedUser == null) {
            doDefault();
            return;
        }
        var widget = survey.getWidget("create");
        widget.context = survey.getCreateContext();

        var html = Renderer.renderDefault("page_survey", "Create", {
            surveyWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doVotePage(args : {survey : Int}) {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged == false) {
            doDefault();
            return;
        }

        var widget = survey.getWidget("vote");
        widget.context = survey.getVoteContext(args.survey);

        var html = Renderer.renderDefault("page_survey", "Vote page", {
            surveyWidget: widget.render()
        });
        Sys.print(html);
    }

    /// Will display choices of the survey if the user hasn't voted yet.
    /// Otherwise, it will display the results of the survey.
    public function doPrintPage(args : {survey_id : Int}) {
        if (Beluga.getInstance().getModuleInstance(Account).isLogged == false) {
            doDefault();
            return;
        }
        if (this.survey.canVote({survey_id : args.survey_id})) {
            doVotePage({survey : args.survey_id});
            return;
        }

        var widget = this.survey.getWidget("print_survey");
        widget.context = this.survey.getPrintContext(args.survey_id);
        var html = Renderer.renderDefault("page_survey", "Display survey", {
            surveyWidget: widget.render()
        });
        Sys.print(html);
    }

    public function doAnswerNotify(args : {title : String, text : String, user_id: Int}) {
        var notification = Beluga.getInstance().getModuleInstance(Notification);
        notification.create(args);
    }
}