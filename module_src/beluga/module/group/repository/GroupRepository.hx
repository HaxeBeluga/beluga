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
import beluga.module.group.model.GroupModel;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

class GroupRepository extends SpodRepository<GroupModel> {

    public function new() {
        super();
    }

    public function isGroupExists(name: String) : Bool {
        var group = GroupModel.manager.search($name == name);
        return group.length > 0 ? true : false;
    }

    public function getFromId(id: Int) : Option<GroupModel> {
        var group = GroupModel.manager.search($id == id).first();
        return (group != null ? Some(group) : None);
    }

    public function getAllGroups() : List<GroupModel> {
        return GroupModel.manager.search(true, {orderBy: id});
    }
}