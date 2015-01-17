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

	//repository
	public var group_repository = new GroupRepository();
	public var member_repository = new MemberRepository();

	public function new() {
		super();
	}

	override public function initialize(beluga : Beluga) : Void {
		this.widgets = new GroupWidget();
		beluga.api.register("group", new GroupApi(beluga, this));
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
                else if (this.group_repository.isGroupExists(args.name) == true) {
                    this.error = GroupAlreadyExists;
                	this.triggers.groupCreationFail.dispatch({error: GroupAlreadyExists});
                }
                else {
                	this.group_repository.save(new GroupModel().init(args.name));
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
            	else if (this.group_repository.isGroupExists(args.new_name) == true) { // FIX IT: Check itself
                    this.error = GroupAlreadyExists;
                	this.triggers.groupModificationFail.dispatch({error: GroupAlreadyExists});
                }
                else {
                	switch (this.group_repository.getFromId(args.id)) {
                		case Some(grp): {
                            grp.name = args.new_name;
                            this.group_repository.update(grp);
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
        		switch (this.group_repository.getFromId(args.id)) {
            		case Some(grp): {
                        this.group_repository.delete(grp);
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

    public function addMember(args: {user_id: Int, group_id: Int}) : Void {
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.memberAdditionFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
        		var user = Beluga.getInstance().getModuleInstance(Account).getUser(args.user_id);
        		if (user == null) {
                    this.error = UserDoesntExist;
        			this.triggers.memberAdditionFail.dispatch({error: UserDoesntExist});
        		}
        		else {
        			var group = switch (this.group_repository.getFromId(args.group_id)) {
        				case Some(grp): grp;
        				case None: {
                            this.error = GroupDoesntExist;
        					this.triggers.memberAdditionFail.dispatch({error: GroupDoesntExist});
        					return;
        				}
        			}
                    switch (this.member_repository.get(user, group)) {
                        case Some(m) : {
                            this.error = MemberAlreadyExists;
                            this.triggers.memberAdditionFail.dispatch({error: MemberAlreadyExists});
                        }
                        case None : {
                            this.member_repository.save(new MemberModel().init(group, user));
                            this.success = MemberAdded;
                            this.triggers.memberAdditionSuccess.dispatch({success: MemberAdded});
                        }
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
        if (!Beluga.getInstance().getModuleInstance(Account).isLogged) {
            this.error = UserNotAuthenticate;
            this.triggers.memberRemovalFail.dispatch({error: UserNotAuthenticate});
        } 
        else {
        	try {
        		var user = Beluga.getInstance().getModuleInstance(Account).getUser(args.user_id);
        		if (user == null) {
                    this.error = UserDoesntExist;
        			this.triggers.memberRemovalFail.dispatch({error: UserDoesntExist});
        		}
        		else {
        			var group = switch (this.group_repository.getFromId(args.group_id)) {
        				case Some(grp): grp;
        				case None: {
                            this.error = GroupDoesntExist;
        					this.triggers.memberRemovalFail.dispatch({error: GroupDoesntExist});
        					return;
        				}
        			}
                    switch (this.member_repository.get(user, group)) {
                        case Some(m) : {
                            this.member_repository.delete(m);
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

}