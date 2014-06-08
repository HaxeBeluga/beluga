package modules.survey_demo;

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

/**
 * Beluga #1
 * @author Guillaume Gomez
 */

class SurveyDemo implements MetadataReader
{
	public var beluga(default, null) : Beluga;
	public var survey(default, null) : Survey;
	private var error_msg : String;
	private var success_msg : String;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
		this.survey = beluga.getModuleInstance(Survey);
		this.error_msg = "";
		this.success_msg = "";
	}

	@bTrigger("beluga_survey_default")
	public static function _doDefault() {
		new SurveyDemo(Beluga.getInstance()).doDefault();
	}

	public function doDefault() {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();
		if (user == null) {
			Web.setHeader("Content-Type", "text/plain");
			Sys.println("Please log in !");
			return;
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

	@bTrigger("beluga_survey_redirect")
	public static function _doRedirectPage() {
		new SurveyDemo(Beluga.getInstance()).doRedirectPage();
	}

	public function doRedirectPage() {
		if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
			Web.setHeader("Content-Type", "text/plain");
			Sys.println("Please log in !");
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

	@bTrigger("beluga_survey_create_fail")
	public static function _doCreateFail() {
		new SurveyDemo(Beluga.getInstance()).doCreateFail();
	}

	public function doCreateFail() {
		error_msg = "Error ! Survey has not been created...";
		this.doDefault();
	}

	@bTrigger("beluga_survey_create_success")
	public static function _doCreateSuccess() {
		new SurveyDemo(Beluga.getInstance()).doCreateSuccess();
	}

	public function doCreateSuccess() {
		success_msg = "Survey has been successfully created !";
		this.doDefault();
	}

	@bTrigger("beluga_survey_delete_success")
	public static function _doDeleteSuccess() {
		new SurveyDemo(Beluga.getInstance()).doDeleteSuccess();
	}

	public function doDeleteSuccess() {
		success_msg = "Survey has been successfully deleted !";
		this.doDefault();
	}

	@bTrigger("beluga_survey_delete_fail")
	public static function _doDeleteFail() {
		new SurveyDemo(Beluga.getInstance()).doDeleteFail();
	}

	public function doDeleteFail() {
		error_msg = "Error when trying to delete survey...";
		this.doDefault();
	}

	public function doCreatePage() {
		if (Beluga.getInstance().getModuleInstance(Account).getLoggedUser() == null) {
			Web.setHeader("Content-Type", "text/plain");
			Sys.println("Please log in !");
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

	@bTrigger("beluga_survey_vote_success")
	public static function _doVoteSuccess() {
		new SurveyDemo(Beluga.getInstance()).doVoteSuccess();
	}

	 public function doVoteSuccess() {
	 	success_msg = "Your vote has been registered";
	 	this.doDefault();
	}

	@bTrigger("beluga_survey_vote_fail")
	public static function _doVoteFail() {
		new SurveyDemo(Beluga.getInstance()).doVoteFail();
	}

	public function doVoteFail() {
	 	error_msg = "Error when registering your vote...";
	 	this.doDefault();
	}

	public function doVotePage(args : {survey : SurveyModel}) {
		if (Beluga.getInstance().getModuleInstance(Account).isLogged() == false) {
			Web.setHeader("Content-Type", "text/plain");
			Sys.println("Please log in !");
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

	@bTrigger("beluga_survey_printx")
	public static function _doPrintPage(args : {survey : SurveyModel}) {
		new SurveyDemo(Beluga.getInstance()).doPrintPage(args);
	}

	public function doPrintPage(args : {survey : SurveyModel}) {
		if (Beluga.getInstance().getModuleInstance(Account).isLogged() == false) {
			Web.setHeader("Content-Type", "text/plain");
			Sys.println("Please log in !");
			return;
		}
		if (this.survey.canVote({id : args.survey.id})) {
			doVotePage({survey : args.survey});
			return;
		}
		var arr = new Array<Dynamic>();
		var choices = new Array<Dynamic>();
		var tot = 0;

		for (tmp_r in Result.manager.dynamicSearch( { survey_id : args.survey.id } )) {
			tot += 1;
			var found = false;
			for (t in arr) {
				if (t.choice_id == tmp_r) {
					t.pourcent += 1;
					found = true;
				}
			}
			if (found == false)
				arr.push({id : tmp_r.choice_id, pourcent : 1});
		}
		for (tmp_c in Choice.manager.dynamicSearch( { survey_id : args.survey.id } )) {
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
		var widget = survey.getWidget("print_survey");
		widget.context = {survey : args.survey, choices : choices, path : "/beluga/survey/"};

		var surveyWidget = widget.render();

		var html = Renderer.renderDefault("page_survey", "Display survey", {
			surveyWidget: surveyWidget
		});
		Sys.print(html);
	}

	@bTrigger("beluga_survey_answer_notify")
	public function _doAnswerNotify(args : {title : String, text : String, user_id: Int}) {
        var notification = Beluga.getInstance().getModuleInstance(Notification);
        notification.create(args);
    }
}