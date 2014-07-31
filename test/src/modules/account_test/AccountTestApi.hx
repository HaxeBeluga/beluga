package modules.account_test;

import haxe.Resource;
import haxe.web.Dispatch;
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.core.macro.MetadataReader;
import beluga.module.account.model.User;
import beluga.module.account.ESubscribeFailCause;
import beluga.module.account.Account;
import modules.account_test.AccountTest;
import main_view.Renderer;

#if php
import php.Web;
#end


/**
 * ...
 * @author brissa_A
 */

class AccountTestApi implements MetadataReader
{
	public var beluga(default, null) : Beluga;
	public var acc(default, null) : Account;

	public function new(beluga : Beluga) {
		this.beluga = beluga;
		this.acc = beluga.getModuleInstance(Account);
	}

	public function doLoginPage() {
		var html = Renderer.renderDefault("page_login", "Authentification", {
			loginWidget: acc.widgets.loginForm.render()
		});
		Sys.print(html);
	}

	public function doSubscribePage() {
        var subscribeWidget = acc.getWidget("subscribe").render();
		var html = Renderer.renderDefault("page_subscribe", "Inscription", {
			subscribeWidget: subscribeWidget
		});
		Sys.print(html);
	}

	public function doPrintInfo() {
		var user = this.acc.loggedUser;

		if (user == null) {
			var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
			Sys.print(html);
			return;
		}
		var subscribeWidget = acc.getWidget("info");
		subscribeWidget.context = {user : user, path : "/accountTest/"};

		var html = Renderer.renderDefault("page_subscribe", "Information", {
			subscribeWidget: subscribeWidget.render()
		});
		Sys.print(html);
	}

	public function doLogout() {
		this.acc.logout();
	}

	public function doDefault(d : Dispatch) {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : ""});
		Sys.print(html);
	}

	public function doEdit() {
		var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

		if (user == null) {
			var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Please log in"});
			Sys.print(html);
			return;
		}
		var subscribeWidget = acc.getWidget("edit");
		subscribeWidget.context = {email : user.email, path : "/accountTest/"};

		var html = Renderer.renderDefault("page_subscribe", "Information", {
			subscribeWidget: subscribeWidget.render()
		});
		Sys.print(html);
	}

	public function doSave(args : {email : String}) {
		this.acc.editEmail(this.acc.loggedUser, args.email);
	}

	public function doEditSuccess() {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "Email address has been changed successfully", error : ""});
		Sys.print(html);
	}
	public function doEditFail() {
		var html = Renderer.renderDefault("page_accueil", "Accueil", {success : "", error : "Error occurred when trying to change email address"});
		Sys.print(html);
	}

}