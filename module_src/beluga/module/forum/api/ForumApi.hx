// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum.api;

import haxe.web.Dispatch;

import beluga.Beluga;
import beluga.BelugaException;

import beluga.module.forum.Forum;

class ForumApi {
    public var beluga : Beluga;
    public var module : Forum;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doDefault() {
        this.module.triggers.defaultForum.dispatch();
    }

    public function doPrint(args : {category_id : Int}) {
        this.module.category_id = (args.category_id == -1 ? None : Some(args.category_id));
        this.module.triggers.defaultForum.dispatch();
    }

    public function doRedirectCreateTopic(args : {category_id : Int}) {
        this.module.category_id = (args.category_id == -1 ? None : Some(args.category_id));
        this.module.triggers.redirectCreateTopic.dispatch();
    }

    public function doRedirectCreateCategory(args : {category_id : Int}) {
        this.module.category_id = (args.category_id == -1 ? None : Some(args.category_id));
        this.module.triggers.redirectCreateCategory.dispatch();
    }

    public function doCreateCategory(args : {name : String, description : String, can_create_topic: Bool, parent_id : Int}) {
        this.module.createCategory(args);
    }

    public function doCreateTopic(args : {title : String, text : String, can_post_message: Bool, category_id : Int}) {
        this.module.createTopic(args);
    }

    public function doPrintTopic(args : {topic_id : Int}) {
        this.module.topic_id = Some(args.topic_id);
        this.module.triggers.printTopic.dispatch();
    }

    public function doRedirectPost(args : {topic_id : Int}) {
        this.module.topic_id = Some(args.topic_id);
        this.module.triggers.redirectPostMessage.dispatch();
    }

    public function doPostMessage(args : {text : String, topic_id : Int, category_id : Int}) {
        this.module.postMessage(args);
    }

    public function doRedirectEditMessage(args : {message_id: Int, topic_id : Int}) {
        this.module.topic_id = Some(args.topic_id);
        this.module.message_id = Some(args.message_id);
        this.module.triggers.redirectEditMessage.dispatch();
    }

    public function doEditMessage(args : {text : String, topic_id : Int, message_id : Int}) {
        this.module.editMessage(args);
    }

    public function doRedirectEditCategory(args : {category_id: Int}) {
        this.module.category_id = Some(args.category_id);
        this.module.triggers.redirectEditCategory.dispatch();
    }

    public function doEditCategory(args : {name : String, description : String, category_id : Int}) {
        this.module.editCategory(args);
    }

    public function doDeleteCategory(args : {category_id : Int, parent_id : Int}) {
        this.module.deleteCategory(args);
    }

    public function doDeleteTopic(args : {topic_id : Int, category_id : Int}) {
        this.module.deleteTopic(args);
    }

    public function doSolveTopic(args : {topic_id : Int, category_id : Int}) {
        this.module.solveTopic(args);
    }

    public function doUnsolveTopic(args : {topic_id : Int, category_id : Int}) {
        this.module.unsolveTopic(args);
    }
}
