// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.forum.Forum;
import beluga.I18n;
import beluga.resource.ResourceManager;
import beluga.module.account.Account;

class Topic extends MttWidget<Forum> {
    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/forum/view/tpl/topic.mtt");
        super(Forum, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/topic/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var topic = switch (mod.topic_id) { case Some(id) : mod.getTopic(id); case None : null;};
        var messages = mod.getAllFromTopic(topic.id);
        var infos = new Array<Dynamic>();

        var author = null;
        for (message in messages) {
            author = message.author;
            infos.push({author: message.author, text: message.text, date: message.date, id: message.id});
        }
        return {
            to_delete: author,
            topic: topic,
            answers: messages,
            user: user,
            error: mod.getErrorString(mod.error_id),
            success: (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            parent: topic.category_id
        };
    }
}