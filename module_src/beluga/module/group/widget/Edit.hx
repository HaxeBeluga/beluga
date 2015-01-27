// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.I18n;

import beluga.module.account.Account;
import beluga.module.account.model.User;

import beluga.module.group.Group;
import beluga.module.group.model.GroupModel;
import beluga.module.group.repository.GroupRepository;
import beluga.module.group.repository.MemberRepository;
import beluga.widget.Layout;

class Edit extends MttWidget<Group> {

    public function new (?layout: Layout) {
        if(layout == null) {
            layout = MttWidget.bootstrap.wrap("/beluga/module/group/view/tpl/edit.mtt");
        }
        super(Group, layout);
        this.i18n = BelugaI18n.loadI18nFolder("/beluga/module/group/view/locale/edit/", mod.i18n);
    }

    override private function getContext() {
        var memberRepository = new MemberRepository();

        return {
            group: this.mod.contextData.group,
            users: memberRepository.getUsersByGroupId(this.mod.contextData.group.id),
            module_name: BelugaI18n.getKey(this.i18n, "group_module_name"),
            error: this.mod.getFailMsg(this.mod.error),
            success: this.mod.getSuccessMsg(this.mod.success)
        };
    }
}