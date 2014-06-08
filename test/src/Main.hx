package ;

import beluga.core.Beluga;
import beluga.core.api.BelugaApi;
import beluga.core.Widget;
import beluga.core.BelugaException;
import haxe.web.Dispatch;
import haxe.Resource;
import haxe.crypto.Md5;
import beluga.module.account.model.User;
import modules.account_demo.AccountDemo;
import modules.account_demo.AccountDemoApi;
import modules.ticket_demo.TicketDemo;
import modules.survey_demo.SurveyDemo;
import modules.fileupload_demo.FileUploadDemo;
import modules.notification_demo.NotificationDemo;
import modules.wallet_demo.WalletDemo;
import modules.market_demo.MarketDemo;
import main_view.Renderer;
import modules.forum_demo.ChannelDemo;
import modules.news_demo.NewsDemo;
import modules.mail_demo.MailDemo;

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


	static function main()
	{
		Assets.build();
		
		try {
			beluga = Beluga.getInstance();
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

	public function doAccountDemo(d : Dispatch) {
		d.dispatch(new AccountDemoApi(beluga));
	}

	public function doTicketDemo(d : Dispatch) {
		d.dispatch(new TicketDemo(beluga));
	}

	public function doSurveyDemo(d : Dispatch) {
		d.dispatch(new SurveyDemo(beluga));
	}

	public function doFileUploadDemo(d : Dispatch) {
		d.dispatch(new FileUploadDemo(beluga));
	}

	public function doNotificationDemo(d : Dispatch) {
		d.dispatch(new NotificationDemo(beluga));
	}

	public function doForumDemo(d : Dispatch) {
		d.dispatch(new ChannelDemo(beluga));
	}

	public function doNewsDemo(d : Dispatch) {
		d.dispatch(new NewsDemo(beluga));
	}

	public function doWalletDemo(d : Dispatch) {
		d.dispatch(new WalletDemo(beluga));
	}

	public function doMailDemo(d : Dispatch) {
		d.dispatch(new MailDemo(beluga));
	}

	public function doMarketDemo(d : Dispatch) {
		d.dispatch(new MarketDemo(beluga));
	}

	public function doAccueil() {
		var html = Renderer.renderDefault("page_accueil", "Accueil",{});
		Sys.print(html);
	}

}