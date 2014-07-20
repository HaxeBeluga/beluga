package ;

import beluga.core.Beluga;
import beluga.core.api.BelugaApi;
import beluga.core.Widget;
import beluga.core.BelugaException;
import beluga.module.account.Account;
import haxe.web.Dispatch;
import haxe.Resource;
import haxe.crypto.Md5;
import beluga.module.account.model.User;
import modules.account_test.AccountTest;
import modules.account_test.AccountTestApi;
import modules.ticket_test.TicketTest;
import modules.survey_test.SurveyTest;
import modules.fileupload_test.FileUploadTest;
import modules.notification_test.NotificationTest;
import modules.wallet_test.WalletTest;
import modules.market_test.MarketTest;
import main_view.Renderer;
import modules.forum_test.ChannelTest;
import modules.news_test.NewsTest;
import modules.mail_test.MailTest;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

/**
 * Beluga #1
 * Load the account class
 * Use it to generate login form, subscribe form, logged homepage
 * @author Masadow
 */

class Main
{
	public static var beluga : Beluga;

	public static var account : AccountTest;

	/*
	 * Exemple of the minimum code to make a working authentification
	 */
	static function mainMinimum() {
		Assets.build();
		var beluga = Beluga.getInstance();
		Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);
		Sys.print(beluga.getModuleInstance(Account).widget.loginForm.render());
		beluga.cleanup();
	}

	static function main()
	{
		Assets.build();

		try {
			beluga = Beluga.getInstance();
			account = new AccountTest(beluga);
			Dispatch.run(beluga.getDispatchUri(), Web.getParams(), new Main());
			beluga.cleanup();
		} catch (e : BelugaException) {
			trace(e);
		}
	}

	public function new() {

	}

	public function doBeluga(d : Dispatch) {
		d.dispatch(beluga.api);
	}

	public function doDebug(d : Dispatch) {
		Web.setHeader("Content-Type", "text/plain");
		trace(Web.getParamsString());
	}

	public function doDefault(d : Dispatch) {
		if (d.parts[0] != "" ) {
			d.dispatch(beluga.api);
		} else {
			doAccueil();
		}
	}

	public function doAccountTest(d : Dispatch) {
		d.dispatch(new AccountTestApi(beluga));
	}

	public function doTicketTest(d : Dispatch) {
		d.dispatch(new TicketTest(beluga));
	}

	public function doSurveyTest(d : Dispatch) {
		d.dispatch(new SurveyTest(beluga));
	}

	public function doFileUploadTest(d : Dispatch) {
		d.dispatch(new FileUploadTest(beluga));
	}

	public function doNotificationTest(d : Dispatch) {
		d.dispatch(new NotificationTest(beluga));
	}

	public function doForumTest(d : Dispatch) {
		d.dispatch(new ChannelTest(beluga));
	}

	public function doNewsTest(d : Dispatch) {
		d.dispatch(new NewsTest(beluga));
	}

	public function doWalletTest(d : Dispatch) {
		d.dispatch(new WalletTest(beluga));
	}

	public function doMailTest(d : Dispatch) {
		d.dispatch(new MailTest(beluga));
	}

	public function doMarketTest(d : Dispatch) {
		d.dispatch(new MarketTest(beluga));
	}

	public function doAccueil() {
		var html = Renderer.renderDefault("page_accueil", "Accueil",{});
		Sys.print(html);
	}

}