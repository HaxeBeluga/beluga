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
			layout = MttWidget.bootstrap.wrap("/beluga/module/group/view/tpl/show.mtt");
		}
        super(Group, layout);
        this.i18n = BelugaI18n.loadI18nFolder("/beluga/module/group/view/locale/show/", mod.i18n);
	}

	override private function getContext() {
		var groupRepository = new GroupRepository();
		var memberRepository = new MemberRepository();
		var user: User = null;
		var groups = new Array<String>();

		 // check if the user is logged
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
        	this.mod.error = UserNotAuthenticate;
        } else { // get the logged user
            user = Beluga.getInstance().getModuleInstance(Account).loggedUser;
            var groupList = groupRepository.getAllGroups();

            trace(groupList);

             for (group in groupList) {
 				groups.push("toto");
 			}
 			for (s in groups) {
 				Sys.print("S IS: " + s + "</br>");
 			}
 			Sys.print("</br>");
 		}

 		trace(groups);
        return {
        	user: user,
        	userGroups: groups,
        	module_name: BelugaI18n.getKey(this.i18n, "group_module_name"),
        	error: this.getFailMsg(this.mod.error),
        	success: this.getSuccessMsg(this.mod.success)
        };
	}

    private function getSuccessMsg(success: GroupSuccessKind) : String {
        return switch (success) {
            case GroupCreated : BelugaI18n.getKey(this.mod.i18n, "suc_GroupAdded");
            case GroupModified : BelugaI18n.getKey(this.mod.i18n, "suc_GroupModified");
            case GroupDeleted : BelugaI18n.getKey(this.mod.i18n, "suc_GroupDeleted");
            case MemberAdded : BelugaI18n.getKey(this.mod.i18n, "suc_MemberAdded");
            case MemberRemoved : BelugaI18n.getKey(this.mod.i18n, "suc_MemberRemoved");
			case None : "";
        };
    }

    private function getFailMsg(error: GroupErrorKind) : String {
        return switch (error) {
            case GroupAlreadyExists : BelugaI18n.getKey(this.mod.i18n, "err_GroupAlreadyExists");
            case GroupDoesntExist : BelugaI18n.getKey(this.mod.i18n, "err_GroupDoesntExist");
            case MemberAlreadyExists : BelugaI18n.getKey(this.mod.i18n, "err_MemberAlreadyExists");
            case MemberDoesntExist : BelugaI18n.getKey(this.mod.i18n, "err_MemberDoesntExist");
            case UserDoesntExist : BelugaI18n.getKey(this.mod.i18n, "err_UserDoesntExist");
            case FieldEmpty : BelugaI18n.getKey(this.mod.i18n, "err_FieldEmpty");
            case UserNotAuthenticate : BelugaI18n.getKey(this.mod.i18n, "err_UserNotAuthenticate");
            case BadFormat : BelugaI18n.getKey(this.mod.i18n, "err_BadFormat");
            case Unexpected : BelugaI18n.getKey(this.mod.i18n, "err_Unexpected");
            case None : "";
        };
    }
}