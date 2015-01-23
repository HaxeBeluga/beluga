// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group;

// Beluga
import beluga.module.Module;
import beluga.Beluga;
import beluga.I18n;

// Beluga mods
import beluga.module.account.Account;
import beluga.module.account.model.User;

import beluga.module.group.GroupErrorKind;
import beluga.module.group.GroupSuccessKind;
import beluga.module.group.model.GroupModel;
import beluga.module.group.model.MemberModel;
import beluga.module.group.api.GroupApi;
import beluga.module.group.repository.GroupRepository;
import beluga.module.group.repository.MemberRepository;


@:Css("/beluga/module/group/view/css/")
class Group extends Module {
	public var triggers = new GroupTrigger();
	public var widgets : GroupWidget;
	public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/group/locale/");
    public var error : GroupErrorKind = None;
    public var success : GroupSuccessKind = None;
    public var contextData : Dynamic;

	//repository
	public var groupRepository = new GroupRepository();
	public var memberRepository = new MemberRepository();

	public function new() {
		super();
	}

	override public function initialize(beluga : Beluga) : Void {
		this.widgets = new GroupWidget();
		beluga.api.register("group", new GroupApi(beluga, this));
    }

    public function getSuccessMsg(success: GroupSuccessKind) : String {
        return switch (success) {
            case GroupCreated : BelugaI18n.getKey(this.i18n, "suc_GroupCreated");
            case GroupModified : BelugaI18n.getKey(this.i18n, "suc_GroupModified");
            case GroupDeleted : BelugaI18n.getKey(this.i18n, "suc_GroupDeleted");
            case MemberAdded : BelugaI18n.getKey(this.i18n, "suc_MemberAdded");
            case MemberRemoved : BelugaI18n.getKey(this.i18n, "suc_MemberRemoved");
            case PageRequested  : "";
            case None : "";
        };
    }

    public function getFailMsg(error: GroupErrorKind) : String {
        return switch (error) {
            case GroupAlreadyExists : BelugaI18n.getKey(this.i18n, "err_GroupAlreadyExists");
            case GroupDoesntExist : BelugaI18n.getKey(this.i18n, "err_GroupDoesntExist");
            case MemberAlreadyExists : BelugaI18n.getKey(this.i18n, "err_MemberAlreadyExists");
            case MemberDoesntExist : BelugaI18n.getKey(this.i18n, "err_MemberDoesntExist");
            case UserDoesntExist : BelugaI18n.getKey(this.i18n, "err_UserDoesntExist");
            case FieldEmpty : BelugaI18n.getKey(this.i18n, "err_FieldEmpty");
            case UserNotAuthenticate : BelugaI18n.getKey(this.i18n, "err_UserNotAuthenticate");
            case BadFormat : BelugaI18n.getKey(this.i18n, "err_BadFormat");
            case Unexpected : BelugaI18n.getKey(this.i18n, "err_Unexpected");
            case None : "";
        };
    }

	public function createGroup(args: {name: String}): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.groupCreationFail.dispatch({error: UserNotAuthenticate});
        }
        else {
            try {
            	if (args.name == "") {
                    this.error = FieldEmpty;
            		this.triggers.groupCreationFail.dispatch({error: FieldEmpty});
            	}
                else if (this.groupRepository.isGroupExists(args.name) == true) {
                    this.error = GroupAlreadyExists;
                	this.triggers.groupCreationFail.dispatch({error: GroupAlreadyExists});
                }
                else {
                	this.groupRepository.save(new GroupModel().init(args.name));
                    this.success = GroupCreated;
                	this.triggers.groupCreationSuccess.dispatch({success: GroupCreated});
                }
            }
            catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.groupCreationFail.dispatch({error: Unexpected});
            }
        }
    }

    public function modifyGroup(args: {id: Int, new_name: String}): Void {
        // Allow to retrieve the edited group to show the edition page
        this.contextData = {
            groupId: args.id
        };

        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.groupModificationFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
				if (args.new_name == "") {
                    this.error = FieldEmpty;
            		this.triggers.groupModificationFail.dispatch({error: FieldEmpty});
            	}
            	else if (this.groupRepository.isGroupExists(args.new_name) == true) {
                    this.error = GroupAlreadyExists;
                	this.triggers.groupModificationFail.dispatch({error: GroupAlreadyExists});
                }
                else {
                	switch (this.groupRepository.getFromId(args.id)) {
                		case Some(grp): {
                            grp.name = args.new_name;
                            this.groupRepository.update(grp);
                            this.success = GroupModified;
                            this.triggers.groupModificationSuccess.dispatch({success: GroupModified});
                        }
                		case None: {
                            this.error = GroupDoesntExist;
                			this.triggers.groupModificationFail.dispatch({error: GroupDoesntExist});
                			return;
                		}
                	}
                }
        	}
			catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.groupModificationFail.dispatch({error: Unexpected});
            }
        }
    }

    public function deleteGroup(args: {id: Int}): Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.groupDeletionFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
        		switch (this.groupRepository.getFromId(args.id)) {
            		case Some(grp): {
                        this.memberRepository.removeMembersInGroup(grp.id);
                        this.groupRepository.delete(grp);
                        this.success = GroupDeleted;
                        this.triggers.groupDeletionSuccess.dispatch({success: GroupDeleted});
                    }
            		case None: {
                        this.error = GroupDoesntExist;
                        this.triggers.groupModificationFail.dispatch({error: GroupDoesntExist});
                    }
            	}
        	}
			catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.groupDeletionFail.dispatch({error: Unexpected});
            }
        }
    }

    public function addMember(args: {user_name: String, group_id: Int}) : Void {
        // Allow to retrieve the edited group to show the edition page
        this.contextData = {
            groupId: args.group_id
        };

        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.memberAdditionFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
                var group = switch (this.groupRepository.getFromId(args.group_id)) {
                    case Some(grp): grp;
                    case None: {
                        this.error = GroupDoesntExist;
                        this.triggers.memberAdditionFail.dispatch({error: GroupDoesntExist});
                        return;
                    }
                }
        		var user = switch (Beluga.getInstance().getModuleInstance(Account).userRepository.getUserByName(args.user_name)) {
                    case Some(usr) : usr;
                    case None : {
                        this.error = UserDoesntExist;
                        this.triggers.memberAdditionFail.dispatch({error: UserDoesntExist});
                        return;
                    }
                }
                switch (this.memberRepository.get(user, group)) {
                    case Some(m) : {
                        this.error = MemberAlreadyExists;
                        this.triggers.memberAdditionFail.dispatch({error: MemberAlreadyExists});
                    }
                    case None : {
                        this.memberRepository.save(new MemberModel().init(group, user));
                        this.success = MemberAdded;
                        this.triggers.memberAdditionSuccess.dispatch({success: MemberAdded});
                    }
                }
        	}
			catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.memberAdditionFail.dispatch({error: Unexpected});
            }
        }
    }

    public function removeMember(args: {user_id: Int, group_id: Int}) : Void {
        // Allow to retrieve the edited group to show the edition page
        this.contextData = {
            groupId: args.group_id
        };

        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.memberRemovalFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
                var group = switch (this.groupRepository.getFromId(args.group_id)) {
                    case Some(grp): grp;
                    case None: {
                        this.error = GroupDoesntExist;
                        this.triggers.memberRemovalFail.dispatch({error: GroupDoesntExist});
                        return;
                    }
                }
        		var user = Beluga.getInstance().getModuleInstance(Account).getUser(args.user_id);
        		if (user == null) {
                    this.error = UserDoesntExist;
        			this.triggers.memberRemovalFail.dispatch({error: UserDoesntExist});
        		}
        		else {
                    switch (this.memberRepository.get(user, group)) {
                        case Some(m) : {
                            this.memberRepository.delete(m);
                            this.success = MemberRemoved;
                            this.triggers.memberRemovalSuccess.dispatch({success: MemberRemoved});
                        }
                        case None : {
                            this.error = MemberDoesntExist;
                            this.triggers.memberRemovalFail.dispatch({error: MemberDoesntExist});
                        }
                    }
        			
        		}
        	}
			catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.memberRemovalFail.dispatch({error: Unexpected});
            }
        }
    }

    public function showGroupPage() : Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.groupShowPageFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
            try {
                this.triggers.groupShowPageSuccess.dispatch({success: PageRequested});
            }
            catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.groupShowPageFail.dispatch({error: Unexpected});
            }
        }
    }

    public function editGroupPage(args: {group_id: Int}) : Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.groupEditionPageFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
            try {
                switch this.groupRepository.getFromId(args.group_id) {
                    case None: {
                        this.error = GroupDoesntExist;
                        this.triggers.groupEditionPageFail.dispatch({error: GroupDoesntExist});
                    }
                    case Some(grp): {
                        this.contextData = {group: grp};
                        this.triggers.groupEditionPageSuccess.dispatch({success: PageRequested});
                    }
                }
            }
            catch(unknown: Dynamic) {
                this.error = Unexpected;
                this.triggers.groupEditionPageFail.dispatch({error: Unexpected});
            }
        }
    }
}
