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

import beluga.widget.Layout;

class Error extends MttWidget<Group> {

    public function new (?layout: Layout) {
        if(layout == null) {
            layout = MttWidget.bootstrap.wrap("/beluga/module/group/view/tpl/error.mtt");
        }
        super(Group, layout);
        this.i18n = BelugaI18n.loadI18nFolder("/beluga/module/group/view/locale/error/", mod.i18n);
    }

    override private function getContext() {
        return {
            module_name: BelugaI18n.getKey(this.i18n, "group_module_name"),
            error: this.mod.getFailMsg(this.mod.error),
            success: this.mod.getSuccessMsg(this.mod.success)
        };
    }
}