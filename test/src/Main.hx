// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package ;

import haxe.macro.Expr;
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
    
    static function main()
    {
        Assets.build();
        try {
            beluga = Beluga.getInstance();
            new AccountTest(beluga);
            ModuleTestApi.addModule("accountTest", new AccountTestApi(beluga));
            ModuleTestApi.addModule("ticketTest", new TicketTest(beluga));
            ModuleTestApi.addModule("surveyTest", new SurveyTest(beluga));
            ModuleTestApi.addModule("fileUploadTest", new FileUploadTest(beluga));
            ModuleTestApi.addModule("notificationTest", new NotificationTest(beluga));
            ModuleTestApi.addModule("forumTest", new ForumTest(beluga));
            ModuleTestApi.addModule("newsTest", new NewsTest(beluga));
            ModuleTestApi.addModule("walletTest", new WalletTest(beluga));
            ModuleTestApi.addModule("mailTest", new MailTest(beluga));
            ModuleTestApi.addModule("marketTest", new MarketTest(beluga));
            ModuleTestApi.addModule("faqTest", new FaqTest(beluga));
            
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

    public function doDebug(d : Dispatch) {
        Web.setHeader("Content-Type", "text/plain");
        trace(Web.getParamsString());
    }

    public function doAccueil() {
        var html = Renderer.renderDefault("page_accueil", "Accueil",{});
        Sys.print(html);
    }

    public function doDefault(module_test_name : String, d : Dispatch) {
        if (module_test_name.length > 0) {
            if (ModuleTestApi.module_test_map.exists(module_test_name)) {
                d.runtimeDispatch(ModuleTestApi.module_test_map[module_test_name]);
            } else {
                trace("No module test found for " + module_test_name);
            }
        } else {
            doAccueil();
        }
    }

}