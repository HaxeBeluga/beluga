// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.forum_test;

import haxe.web.Dispatch;
import haxe.Resource;
import haxe.CallStack;

import main_view.Renderer;

import beluga.Beluga;
import beluga.module.account.model.User;
import beluga.module.account.Account;
import beluga.module.forum.Forum;
import beluga.module.forum.ForumErrorKind;

#if php
import php.Web;
#end

class ForumTest {
    public var beluga(default, null) : Beluga;
    public var forum(default, null) : Forum;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.forum = beluga.getModuleInstance(Forum);

        this.forum.triggers.defaultForum.add(this.doDefault);
        this.forum.triggers.redirectCreateTopic.add(this.redirectCreateTopic);
        this.forum.triggers.redirectCreateCategory.add(this.redirectCreateCategory);
        this.forum.triggers.createTopicFail.add(this.createTopicFail);
        this.forum.triggers.createTopicSuccess.add(this.doDefault);
        this.forum.triggers.createCategoryFail.add(this.createCategoryFail);
        this.forum.triggers.createCategorySuccess.add(this.doDefault);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_forum", "Forum", {
            forumWidget: forum.widgets.forum.render()
        });
        Sys.print(html);
    }

    public function redirectCreateCategory() {
        /*var html = Renderer.renderDefault("page_forum", "Forum", {
            forumWidget: forum.widgets.create_category.render()
        });
        Sys.print(html);*/
        Sys.print("pute !");
    }

    public function createCategoryFail(args : {error : ForumErrorKind}) {
        return redirectCreateCategory();
    }

    public function redirectCreateTopic() {
        var html = Renderer.renderDefault("page_forum", "Forum", {
            forumWidget: forum.widgets.create_topic.render()
        });
        Sys.print(html);
    }

    public function createTopicFail(args : {error : ForumErrorKind}) {
        return redirectCreateTopic();
    }
}