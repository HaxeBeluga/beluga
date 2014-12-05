// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package ;

import main_view.Renderer;

import beluga.Beluga;
import beluga.api.BelugaApi;
import beluga.BelugaException;
import beluga.log.Log;

import beluga.module.account.Account;
import beluga.module.account.model.User;

import haxe.web.Dispatch;
import haxe.Resource;
import haxe.crypto.Md5;

import modules.account_test.AccountTest;
import modules.account_test.AccountTestApi;
import modules.ticket_test.TicketTest;
import modules.survey_test.SurveyTest;
import modules.fileupload_test.FileUploadTest;
import modules.notification_test.NotificationTest;
import modules.wallet_test.WalletTest;
import modules.market_test.MarketTest;
import modules.forum_test.ForumTest;
import modules.news_test.NewsTest;
import modules.mail_test.MailTest;
import modules.faq_test.FaqTest;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

/**
 * Beluga #1
 * Load the account class
 * Use it to generate login form, subscribe form, logged homepage
 */

class Main {
    public static var beluga : Beluga;

    public static var account : AccountTest;
    public static var file_upload : FileUploadTest;
    public static var ticket : TicketTest;
    public static var survey : SurveyTest;
    public static var market : MarketTest;
    public static var wallet : WalletTest;
    public static var news : NewsTest;
    public static var faq : FaqTest;
    public static var mail : MailTest;
    public static var notification: NotificationTest;
    public static var forum : ForumTest;

    static function main()
    {
        Assets.build();

        try {
            beluga = Beluga.getInstance();
            account = new AccountTest(beluga);
            file_upload = new FileUploadTest(beluga);
            ticket = new TicketTest(beluga);
            survey = new SurveyTest(beluga);
            market = new MarketTest(beluga);
            wallet = new WalletTest(beluga);
            faq = new FaqTest(beluga);
            news = new NewsTest(beluga);
            mail = new MailTest(beluga);
            notification = new NotificationTest(beluga);
            forum = new ForumTest(beluga);
            if (!beluga.handleRequest()) {
                Dispatch.run(beluga.getDispatchUri(), Web.getParams(), new Main());
            }
            beluga.cleanup();
            Log.flush();
        } catch (e: BelugaException) {
            trace(e);
        }
    }

    public function new() {
    }
    
    public function doDefault(d : Dispatch) {
        doAccueil();
    }

    public function doDebug(d : Dispatch) {
        Web.setHeader("Content-Type", "text/plain");
        trace(Web.getParamsString());
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
        d.dispatch(new ForumTest(beluga));
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

    public function doFaqTest(d : Dispatch) {
        d.dispatch(new FaqTest(beluga));
    }

    public function doAccueil() {
        var html = Renderer.renderDefault("page_accueil", "Accueil",{});
        Sys.print(html);
    }
}