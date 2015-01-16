// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.group_test;

// Beluga
import beluga.Beluga;
import beluga.module.group.Group;
import beluga.module.group.GroupErrorKind;
import beluga.module.account.Account;

// BelugaTest
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class GroupTest {
    public var beluga(default, null) : Beluga;
    public var group(default, null) : Group;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.group = beluga.getModuleInstance(Group);
        this.group.triggers.groupCreationSuccess.add(this.doDefault);
    }

    public function doDefault() {
        var html = Renderer.renderDefault("page_group_widget", "Group", {
            groupWidget: this.group.widgets.show.render()
        });
        Sys.print(html);
    }
}