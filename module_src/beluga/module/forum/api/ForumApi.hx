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

    public function doRedirectCreateTopic(args : {category_id : Int}) {
        this.module.category_id = (args.category_id == -1 ? None : Some(args.category_id));
        this.module.triggers.redirectCreateTopic.dispatch();
    }

    public function doRedirectCreateCategory(args : {category_id : Int}) {
        this.module.category_id = (args.category_id == -1 ? None : Some(args.category_id));
        this.module.triggers.redirectCreateCategory.dispatch();
    }
}
