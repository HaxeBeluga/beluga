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
        return MemberModel.manager.search($user_id == id) != null;
    }

    public function getMembersByGroupId(groupId : Int) : List<MemberModel> {
        return MemberModel.manager.search($group_id == groupId);
    }

    public function getUsersByGroupId(groupId : Int) : List<User> {
        var users = new List<User>();
        for (member in this.getMembersByGroupId(groupId)) {
            users.push(member.user);
        }
        return users;
    }

    public function getFromId(id: Int): Option<User> {
        if (id < 0) {
            return None;
        }
        var user = User.manager.get(id);
        return (user != null ? Some(user) : None);
    }

    public function get(user: User, group: GroupModel) : Option<MemberModel> {
        var member = MemberModel.manager.search($user == user && $group == group).first();
        if (member == null) {
            return None;
        }
        return (member != null ? Some(member) : None);
    }

    public function removeMembersInGroup(groupId : Int) : Void {
        for (user in this.getMembersByGroupId(groupId)) {
            this.delete(user);
        }
    }
}