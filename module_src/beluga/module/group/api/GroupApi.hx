// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.Beluga;
import beluga.BelugaException;

// Beluga mods
import beluga.module.group.Group;

class GroupApi {
    public var beluga : Beluga;
    public var module : Group;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doCreateGroup(args: {name: String}) : Void {
        this.module.createGroup(args);
    }

    public function doModifyGroup(args: {id: Int, new_name: String}) : Void {
        this.module.modifyGroup(args);
    }

    public function doDeleteGroup(args: {id: Int}) : Void {
        this.module.deleteGroup(args);
    }

    public function doAddMember(args: {user_name: String, group_id: Int}) : Void {
        this.module.addMember(args);
    }

    public function doRemoveMember(args: {user_id: Int, group_id: Int}) : Void {
        this.module.removeMember(args);
    }

    public function doEditGroup(args: {group_id : Int}) : Void {
        this.module.editGroupPage(args);
    }

    public function doShowGroup() : Void {
        this.module.showGroupPage();  
    }

    public function doDefault() : Void {
        this.doShowGroup();
    }
}