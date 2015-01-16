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
        return group != null;
    }

    public function getFromId(id: Int): Option<GroupModel> {
        if (id < 0) {
            return None;
        }
        var group = GroupModel.manager.get(id);
        if (group == null) {
            return None;
        }
        return (group != null ? Some(group) : None);
    }
}