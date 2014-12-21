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
import beluga.widget.Layout;

class EditMessage extends MttWidget<Forum> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/forum/view/tpl/edit_message.mtt");
        super(Forum, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/edit_message/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        var topic = switch (mod.topic_id) { case Some(id) : mod.getTopic(id); case None : null;};
        // if topic doesn't exist, we display default page
        if (topic == null) {
            mod.error_id = UnknownMessage;
            var ret = mod.widgets.forum.getContext();

            ret.other = mod.widgets.forum.render();
            return ret;
        }
        var message = switch (mod.message_id) { case Some(id) : mod.getMessage(id); case None : null;};

        // if message doesn't exist or isn't in topic, we display default page
        if (message == null || message.topic_id != topic.id) {
            mod.error_id = UnknownMessage;
            var ret = mod.widgets.forum.getContext();

            ret.other = mod.widgets.forum.render();
            return ret;
        }
        return {
            topic: topic,
            message: message,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            user: user,
            module_name: "Forum edit message"
        };
    }
}