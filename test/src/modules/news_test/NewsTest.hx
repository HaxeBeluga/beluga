// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.news_test;

import haxe.web.Dispatch;
import haxe.Resource;
import haxe.CallStack;

import main_view.Renderer;

import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.news.News;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;
import beluga.module.news.NewsErrorKind;

#if php
import php.Web;
#end

class NewsTest {
    public var beluga(default, null) : Beluga;
    public var news(default, null) : News;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.news = beluga.getModuleInstance(News);
        this.news.triggers.defaultNews.add(this.doDefault);
        this.news.triggers.print.add(this.print);
        this.news.triggers.redirect.add(this.redirect);
        this.news.triggers.redirectEdit.add(this.redirectEdit);
        this.news.triggers.deleteCommentFail.add(this.deleteCommentFail);
        this.news.triggers.deleteCommentSuccess.add(this.print);
        this.news.triggers.createSuccess.add(this.doDefault);
        this.news.triggers.createFail.add(this.createFail);
        this.news.triggers.editSuccess.add(this.print);
        this.news.triggers.editFail.add(this.editFail);
        this.news.triggers.addCommentSuccess.add(this.print);
        this.news.triggers.addCommentFail.add(this.addCommentFail);
        this.news.triggers.deleteSuccess.add(this.doDefault);
        this.news.triggers.deleteFail.add(this.deleteFail);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_news", "News list", {
            newsWidget: news.widgets.news.render()
        });
        Sys.print(html);
    }

    /// FIXME : Check why page is generated twice
    public function print() {
        var html = Renderer.renderDefault("page_news", "News list", {
            newsWidget: news.widgets.print.render()
        });
        Sys.print(html);
    }

    public function redirect() {
        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: news.widgets.create.render()
        });
        Sys.print(html);
    }

    public function redirectEdit() {
        var html = Renderer.renderDefault("page_news", "Create news", {
            newsWidget: news.widgets.edit.render()
        });
        Sys.print(html);
    }

    public function deleteCommentFail(args : {error : NewsErrorKind}) {
        this.print();
    }

    public function addCommentFail(args : {error : NewsErrorKind}) {
        this.print();
    }

    public function deleteFail(args : {error : NewsErrorKind}) {
        this.print();
    }

    public function createFail(args : {error : NewsErrorKind}) {
        this.redirect();
    }


    public function editFail(args : {error : NewsErrorKind}) {
        this.redirectEdit();
    }
}