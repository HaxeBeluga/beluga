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
import beluga.widget.Layout;

class MessageData {
    public var author_login: String;
    public var message: String;
    public var id: Int;
    public var date: Date;

    public function new(login: String, message: String, id: Int, date: Date) {
        this.author_login = login;
        this.message = message;
        this.id = id;
        this.date = date;
    }
}

class Topic extends MttWidget<Forum> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/forum/view/tpl/topic.mtt");
        super(Forum, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/topic/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        var topic = switch (mod.topic_id) { case Some(id) : mod.getTopic(id); case None : null;};
        var messages = mod.getAllFromTopic(topic.id);
        var infos = new Array<MessageData>();

        for (message in messages) {
            infos.push(new MessageData((message.author == null || message.author.login == null) ? "Account deleted" : message.author.login,
                message.text, message.id, message.date));
        }
        return {
            topic: topic,
            answers: messages,
            user: user,
            error: mod.getErrorString(mod.error_id),
            success: (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            parent: topic.category_id,
            module_name: "Forum topic"
        };
    }
}