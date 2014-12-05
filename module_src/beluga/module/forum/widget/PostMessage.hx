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

class PostMessage extends MttWidget<Forum> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/forum/view/tpl/post_message.mtt");
        super(Forum, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/post_message/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var topic = switch (mod.topic_id) { case Some(id) : mod.getTopic(id); case None : null;};
        // if topic doesn't exist, we display default page
        if (topic == null) {
            mod.error_id = UnknownTopic;
            var ret = mod.widgets.forum.getContext();

            ret.other = mod.widgets.forum.render();
            return ret;
        }
        if (topic.can_post_message == false && user.isAdmin == false) {
            mod.error_id = NotAllowed;
            var ret = mod.widgets.topic.getContext();

            ret.other = mod.widgets.topic.render();
            return ret;
        }
        
        return {
            category_id: topic.category_id,
            topic: topic,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            user: user,
            answer: mod.answer
        };
    }
}