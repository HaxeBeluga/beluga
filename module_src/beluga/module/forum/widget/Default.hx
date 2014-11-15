// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum.widget;

import sys.db.Types;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.forum.Forum;
import beluga.module.forum.CategoryData;
import beluga.module.account.Account;
import beluga.resource.ResourceManager;

class Default extends MttWidget<Forum> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/forum/view/tpl/default.mtt");
        super(Forum, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/default/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var categories = mod.getAllFromCategory(mod.category_id);
        var categories_array = new Array<Dynamic>();
        var topics_array = new Array<Dynamic>();

        for (category in categories.categories) {
            var category_data = mod.getAllFromCategory(Some(category.id));

            categories_array.push({title: category.name, number_of_topics: category_data.topics.length, last_message : "test"});
        }
        for (topic in categories.topics) {
            var messages = mod.getAllFromTopic(topic.id);

            topics_array.push({title: topic.title, number_of_messages: messages.length, last_message : "test"});
        }
        return {
            category_id: switch (mod.category_id) { case Some(id) : id; case None : -1;},
            categories : categories_array,
            topics : topics_array,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            user: user
        };
    }
}