// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group.repository;

// beluga core
import beluga.module.SpodRepository;

// beluga mods
import beluga.module.account.model.User;
import beluga.module.group.model.GroupModel;
import beluga.module.group.model.MemberModel;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

class MemberRepository extends SpodRepository<MemberModel> {

    public function new() {
        super();
    }

    public function isMemberInGroup(id: Int) : Bool {
        var member = MemberModel.manager.search($user_id == id);
        return member != null;
    }

    public function getUsersSortedByGroup() : List<{group: GroupModel, users: List<User>}> {
        var members = MemberModel.manager.search(true, {orderBy: group_id});
        
        var sortedMembers = new List<{group: GroupModel, users: List<User>}>();
        var currentGroup : {group: GroupModel, users: List<User>} = {group: null, users: null};

        for (member in members) {
            if (currentGroup.group != member.group) {
                sortedMembers.add(currentGroup);
                currentGroup.group = member.group;
                currentGroup.users = new List<User>();
            }
            currentGroup.users.add(member.user);
        }
        return sortedMembers;
    }

    public function getFromId(id: Int): Option<User> {
        if (id < 0) {
            return None;
        }
        var user = User.manager.get(id);
        if (user == null) {
            return None;
        }
        return (user != null ? Some(user) : None);
    }

    public function get(user: User, group: GroupModel) : Option<MemberModel> {
        var member = MemberModel.manager.search($user == user && $group == group).first();
        if (member == null) {
            return None;
        }
        return Some(member);
    }
}