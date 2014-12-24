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
import beluga.widget.Layout;

class CreateTopic extends MttWidget<Forum> {
    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/forum/view/tpl/create_topic.mtt");
        super(Forum, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/create_topic/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        return {
            path : "/beluga/forum/",
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            parent : switch (mod.category_id) { case Some(id) : id; case None : -1;},
            base_url : ConfigLoader.getBaseUrl(),
            answer: mod.answer,
            module_name: BelugaI18n.getKey(this.i18n, "topic_creation")
        };
    }
}