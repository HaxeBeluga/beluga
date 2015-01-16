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

class Show extends MttWidget<Group> {

	public function new (?layout: Layout) {
		if(layout == null) {
			layout = Layout.newFromPath("/beluga/module/group/view/tpl/show.mtt");
		}
        super(Group, layout);
        this.i18n = BelugaI18n.loadI18nFolder("/beluga/module/group/view/locale/show/", mod.i18n);
	}

	override private function getContext() {
		var group_repository = new GroupRepository();
		var member_repository = new MemberRepository();
		var user: User = null;
		var user_authenticated = true;
		var groups : List<{group: GroupModel, users: List<User>}>;

		 // check if the user is logged
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            user_authenticated = false;
        } else { // get the logged user
            user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
        }

 		groups = member_repository.getUsersSortedByGroup();

        return {
        	user_authenticated: user_authenticated,
        	user: user,
        	groups: groups
        };
	}
}