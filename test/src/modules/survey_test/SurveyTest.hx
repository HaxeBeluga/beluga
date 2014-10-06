// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.survey_test;

import haxe.web.Dispatch;
import haxe.Resource;
import main_view.Renderer;

import beluga.core.Beluga;
import beluga.core.Widget;

import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.survey.Survey;
import beluga.module.survey.SurveyErrorKind;
import beluga.module.survey.model.SurveyModel;
import beluga.module.survey.model.Choice;
import beluga.module.survey.model.Result;
import beluga.module.notification.Notification;

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
        this.survey.triggers.createFail.add(this.createFail);
        this.survey.triggers.deleteFail.add(this.deleteFail);
        this.survey.triggers.deleteSuccess.add(this.doDefault);
        this.survey.triggers.voteFail.add(this.voteFail);
        this.survey.triggers.voteSuccess.add(this.doVotePage);
        this.survey.triggers.printSurvey.add(this.doPrintPage);
        this.survey.triggers.answerNotify.add(this.doAnswerNotify);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_survey", "Surveys list", {
            surveyWidget: survey.widgets.survey.render()
        });
        Sys.print(html);
    }

    public function doRedirectPage() {
        var html = Renderer.renderDefault("page_survey", "Create survey", {
            surveyWidget: survey.widgets.create.render()
        });
        Sys.print(html);
    }

    public function deleteFail(args : {error : SurveyErrorKind}) {
        this.doDefault();
    }

    public function doCreatePage() {
        var html = Renderer.renderDefault("page_survey", "Create survey", {
            surveyWidget: survey.widgets.create.render()
        });
        Sys.print(html);
    }

    public function createFail(args : {error : SurveyErrorKind}) {
        this.doCreatePage();
    }

    public function doVotePage() {
        var html = Renderer.renderDefault("page_survey", "Vote page", {
            surveyWidget: survey.widgets.vote.render()
        });
        Sys.print(html);
    }

    public function voteFail(args : {error : SurveyErrorKind}) {
        this.doVotePage();
    }

    /// Will display choices of the survey if the user hasn't voted yet.
    /// Otherwise, it will display the results of the survey.
    public function doPrintPage() {
        if (this.survey.canVote(survey.getActualSurveyId())) {
            doVotePage();
            return;
        }

        var html = Renderer.renderDefault("page_survey", "Display survey", {
            surveyWidget: survey.widgets.print.render()
        });
        Sys.print(html);
    }

    public function doAnswerNotify(args : {title : String, text : String, user_id: Int}) {
        var notification = Beluga.getInstance().getModuleInstance(Notification);
        notification.create(args);
    }
}